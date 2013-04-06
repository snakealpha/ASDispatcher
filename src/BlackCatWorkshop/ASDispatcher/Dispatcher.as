/**
 *  License.
 * 
 * 	Copyright (C) 2013 Snake. Liu
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 */
package BlackCatWorkshop.ASDispatcher
{
	import flash.utils.Dictionary;

	/**
	 * Main class of this library.
	 * Dispatcher is a singleton while all functions should be used through static methods.
	 * You can use Dispatcher as a global EventDispatcher class, althougn it's not. Methods are EventDispatcher style, but some arguments are not the same.
	 */
	public class Dispatcher
	{
		private static var _instance:Dispatcher;
		
		private var channels:Dictionary = new Dictionary();
		
		public function Dispatcher()
		{
			channels["default"] = new Channel();
		}
		
		private static function get instance():Dispatcher
		{
			if(_instance == null)
				_instance = new Dispatcher();
			
			return _instance;
		}
		
		/**
		 * Add a new event listener.
		 * 
		 * @param eventName 			Type of event that will be dispathced.
		 * @param functionBody 			A callback function that will be called when a matched Event has been thrown. Should accept a argument as DataEvent.
		 * @param channel				Channel defines a collection of callbacks receive current event. 
		 * 								Callbacks added with a different channel will not receive events dispatched with a specific channel, even if they share a same eventName.
		 * 								With putting events into different channels, dispatcher will run a little faster. 
		 * @param priority				Callbacks have less number as priority will run sooner. If more than one callbacks share a priority, callbacks added sooner will run sooner.
		 * @param isPriorityBlocked		If a callback is added with this argument as true, all callbacks with larger priority number will not run.
		 * @param isCallBlocked			If a callback is added with this argument as true, all callbacks should run after this one will not run.
		 * 
		 */
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
		
		/**
		 * Remove a existed event Listener.
		 * If more than one listeners have been added, all of them in current channel will be removed.
		 * If no listener existed, method will return directly.
		 * 
		 * @param eventName 			Type of event that will be dispathced.
		 * @param functionBody 			A callback function that will be called when a matched Event has been thrown. Should accept a argument as DataEvent.
		 * @param channel				Channel defines a collection of callbacks receive current event. 
		 * 								Callbacks added with a different channel will not receive events dispatched with a specific channel, even if they share a same eventName.
		 * 								With putting events into different channels, dispatcher will run a little faster. 
		 * 
		 */
		public static function removeEventListener(eventName:String, 
												   functionBody:Function, 
												   channel:String = "default"):void
		{
			if(!instance.channels.hasOwnProperty(channel))
			{
				return;
			}
			
			var channelInstance:Channel = Channel(instance.channels[channel]);
			channelInstance.deleteCallback(eventName, functionBody);
		}
		
		/**
		 * Check if a event listener is existed in a specified channel.
		 * 
		 * @param eventName 			Type of event that will be dispathced.
		 * @param functionBody 			A callback function that will be called when a matched Event has been thrown. Should accept a argument as DataEvent.
		 * @param channel				Channel defines a collection of callbacks receive current event. 
		 * 								Callbacks added with a different channel will not receive events dispatched with a specific channel, even if they share a same eventName.
		 * 								With putting events into different channels, dispatcher will run a little faster. 
		 * 
		 */
		public static function hasEventListener(eventName:String, 
												functionBody:Function, 
												channel:String = "default"):Boolean
		{
			if(!instance.channels.hasOwnProperty(channel))
			{
				return false;
			}
			
			var channelInstance:Channel = Channel(instance.channels[channel]);
			return channelInstance.hasCallback(eventName, functionBody);
		}
		
		/**
		 * Dispatch a event in a specified channel.
		 * 
		 * @param event 				Type of event that will be dispathced.
		 * @param data 					Data object which will passed as data field of DataEvent.
		 * @param channel				Channel defines a collection of callbacks receive current event. 
		 * 								Callbacks added with a different channel will not receive events dispatched with a specific channel, even if they share a same eventName.
		 * 								With putting events into different channels, dispatcher will run a little faster. 
		 */
		public static function dispatchEvent(event:String, 
											 data:Object = null, 
											 channel:String = "default"):void
		{
			dispatchEventObject(new DataEvent(event, data), channel);
		}
		
		/**
		 * Dispatch a event in a specified channel.
		 * This method will dispatch a event object directly.
		 * If you want to dispatched a custom event, this method will be your choosen.
		 * 
		 * @param eventObject 			Event object that will be dispathced.
		 * @param channel				Channel defines a collection of callbacks receive current event. 
		 * 								Callbacks added with a different channel will not receive events dispatched with a specific channel, even if they share a same eventName.
		 * 								With putting events into different channels, dispatcher will run a little faster. 
		 */
		public static function dispatchEventObject(eventObject:DataEvent, channel:String = "default"):void
		{
			if(!instance.channels.hasOwnProperty(channel))
			{
				instance.channels[channel] = new Channel();
			}
			var channelInstance:Channel = Channel(instance.channels[channel]);
			channelInstance.callCallback(eventObject);
		}
	}
}