package BlackCatWorkshop.ASDispatcher
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		private var _data:Object;
		
		public function DataEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		/**
		 * Data object that has been passed as the data argument while constructing.
		 */
		public function get data():Object
		{
			return _data;
		}
	}
}