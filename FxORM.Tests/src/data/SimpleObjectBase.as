package data
{
	import IPersistentObject;

import interfaces.IEntityManager;

import mx.collections.ArrayCollection;

	public class SimpleObjectBase extends PersistentObject
	{
		private var _intCollection : ArrayCollection; 
		private var _stringCollection : ArrayCollection;
		private var _stringValue : String;
		private var _intValue : int;
		private var _floatValue : Number;
		private var _dateValue : Date;
		public var noDBValue : int = 1232;
		
		[Column]
		public var boolValue : Boolean;
		
		[Column(name="dateValue")]
		public function get dateValue():Date
		{
			return _dateValue;
		}

		public function set dateValue(value:Date):void
		{
			_dateValue = value;
			setPrimitiveValue("dateValue", value);
		}

		[Column(name="floatValue")]
		public function get floatValue():Number
		{
			return _floatValue;
		}

		public function set floatValue(value:Number):void
		{
			_floatValue = value;
			setPrimitiveValue("floatValue", value);
		}

		[Column(name="intValue")]
		public function get intValue():int
		{
			return _intValue;
		}

		public function set intValue(value:int):void
		{
			_intValue = value;
			setPrimitiveValue("intValue", value);
		}

		[Column(name="stringValue")]
		public function get stringValue():String
		{
			return _stringValue;
		}

		public function set stringValue(value:String):void
		{
			_stringValue = value;
			setPrimitiveValue("stringValue", value);
		}

		
		[Column(name="stringCollection", collectionItemType="String")]
		public function get stringCollection():ArrayCollection
		{
			if (!_stringCollection) 
			{
				_stringCollection = new ArrayCollection();
				setPrimitiveValue("stringCollection", _stringCollection);
			}
			return _stringCollection;
		}
		
		public function set stringCollection(value:ArrayCollection):void
		{
			_stringCollection = value;
			setPrimitiveValue("stringCollection", value);
		}
		
		[Column(name="intCollection", collectionItemType="uint")]
		public function get intCollection():ArrayCollection
		{
			if (!_intCollection) 
			{
				_intCollection = new ArrayCollection();
				setPrimitiveValue("intCollection", _intCollection);
			}
			return _intCollection;
		}
		
		public function set intCollection(value:ArrayCollection):void
		{
			_intCollection = value;
			setPrimitiveValue("intCollection", value);
		}
	}
}