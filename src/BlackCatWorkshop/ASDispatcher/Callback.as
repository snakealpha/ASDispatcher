package BlackCatWorkshop.ASDispatcher
{
	internal class Callback
	{
		private var _key:String;
		private var _callback:Function;
		
		private var _isPriorityBlock:Boolean = false;
		private var _isCallBlock:Boolean = false;
		
		public function Callback(key:String, 
								 callback:Function, 
								 isPriorityBlock:Boolean = false, 
								 isCallBlock:Boolean = false)
		{
			_key = key;
			_callback =callback; 
			_isPriorityBlock = isPriorityBlock;
			_isCallBlock = isCallBlock;
		}
		
		public function get key():String
		{
			return _key;
		}
		
		public function get callback():Function
		{
			return _callback;
		}
		
		/**
		 * While isPriorityBlock of a callback is true, all callbacks that priority class is larger than current will not run. But callbacks with the same priority will run all the same.
		 **/
		public function get isPriorityBlock():Boolean
		{
			return _isPriorityBlock;
		}
		
		/**
		 * While isCallBlock is true, all callbacks still have not be called will not be called at all. Callbacks that registered later will be blocked, event if they have a same priority class as current callback.
		 **/
		public function get isCallBlock():Boolean
		{
			return _isCallBlock;
		}
		
		public function call(arg:DataEvent):void
		{
			_callback(arg);
		}
	}
}