package BlackCatWorkshop.ASDispatcher
{
	public class Channel
	{
		private var _callbacks:Array = [];
		
		public function Channel()
		{
			super();
			
			for(var priority:uint = 0; priority != 256; priority++)
			{
				_callbacks.push(new Array());
			}
		}
		
		public function addCallback(callback:Callback, priority:uint = 128):void
		{
			_callbacks[priority].push(callback);
		}
		
		public function deleteCallback(eventName:String, functionBody:Function):void
		{
			for each(var coPriorityCallbacks:Array in _callbacks)
			{
				for(var i:uint = 0; i != coPriorityCallbacks.length; i++)
				{
					var callback:Callback = Callback(coPriorityCallbacks[i]);
					
					if(callback.key == eventName && callback.callback == functionBody)
					{
						coPriorityCallbacks.splice(i, 1);
						i--;
					}
				}
			}
		}
		
		public function hasCallback(eventName:String, 
									functionBody:Function):Boolean
		{
			for each(var coPriorityCallbacks:Array in _callbacks)
			{
				for each(var callback:Callback in coPriorityCallbacks)
				{
					if(callback.key == eventName && callback.callback == functionBody)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function callCallback(event:DataEvent):void
		{
			var isBlocked:Boolean = false;
			
			for(var prioLevel:uint = 0; prioLevel != _callbacks.length; prioLevel++)
			{
				var coLevelCallbacks:Array = _callbacks[prioLevel] as Array;
				
				for(var i:uint = 0; i != coLevelCallbacks.length; i++)
				{
					var callBack:Callback = Callback(coLevelCallbacks[i]);
					
					if(event.type == callBack.key)
					{
						callBack.call(event);
						
						if(callBack.isPriorityBlock || callBack.isCallBlock)
						{
							isBlocked = true;
						}
						if(callBack.isCallBlock)
						{
							break;
						}
					}
				}
				
				if(isBlocked)
				{
					break;
				}
			}
		}
	}
}