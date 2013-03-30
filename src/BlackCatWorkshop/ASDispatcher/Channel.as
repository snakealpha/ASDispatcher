package BlackCatWorkshop.ASDispatcher
{
	/**
	 *  License.
	 * 
	 * 	Copyright (C) 2013 Snake. Liu
 	 *	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 	 *	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 	 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	 * 
 	 */
	
	
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