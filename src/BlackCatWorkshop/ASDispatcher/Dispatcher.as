package BlackCatWorkshop.ASDispatcher
{
	import flash.utils.Dictionary;

	public class Dispatcher
	{
		private static var _instance:Dispatcher;
		
		private var channels:Dictionary = new Dictionary();
		
		public function Dispatcher()
		{
			channels["default"] = new Channel();
		}
		
		public static function get instance():Dispatcher
		{
			if(_instance == null)
				_instance = new Dispatcher();
			
			return _instance;
		}
		
		public static function addEventListener(eventName:String, 
												functionBody:Function, 
												channel:String = "default", 
												priority:uint = 128,
												isPriorityBlocked:Boolean = false,
												isCallBlocked:Boolean = false):void
		{
			var callback:Callback = new Callback(eventName, functionBody, isPriorityBlocked, isCallBlocked);
			
			if(!instance.channels.hasOwnProperty(channel))
			{
				instance.channels[channel] = new Channel();
			}
			
			var channelInstance:Channel = Channel(instance.channels[channel]);
			channelInstance.addCallback(callback, priority);
		}
		
		public static function removeEventListener(eventName:String, 
												   functionBody:Function, 
												   channel:String = "default"):void
		{
			var channelInstance:Channel = Channel(instance.channels[channel]);
			channelInstance.deleteCallback(eventName, functionBody);
		}
		
		public static function hasEventListener(eventName:String, 
												functionBody:Function, 
												channel:String = "default"):Boolean
		{
			var channelInstance:Channel = Channel(instance.channels[channel]);
			return channelInstance.hasCallback(eventName, functionBody);
		}
		
		public static function dispatchEvent(event:DataEvent, channel:String = "default"):void
		{
			var channelInstance:Channel = Channel(instance.channels[channel]);
			channelInstance.callCallback(event);
		}
	}
}