package data
{
import interfaces.IEntityManager;

import mx.collections.ArrayCollection;

	[Table("simpleObjects")]
	public class SimpleObject extends SimpleObjectBase
	{
		private var _midLevelProperty : String;
		public function SimpleObject()
		{
			super();
		}

		[Column(name="midLevelProperty")]
		public function get midLevelProperty():String
		{
			return _midLevelProperty;
		}

		public function set midLevelProperty(value:String):void
		{
			_midLevelProperty = value;
			setPrimitiveValue("midLevelProperty", value);
		}
		
		

	}
}