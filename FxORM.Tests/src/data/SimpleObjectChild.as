package data
{
import interfaces.IEntityManager;

public class SimpleObjectChild extends SimpleObject
	{
		private var _childValue : String;
		public function SimpleObjectChild()
		{
			super();
		}
		[Column(name="childValue")]
		public function get childValue():String
		{
			return _childValue;
		}

		public function set childValue(value:String):void
		{
			_childValue = value;
			setPrimitiveValue("childValue", value);
		}

	}
}