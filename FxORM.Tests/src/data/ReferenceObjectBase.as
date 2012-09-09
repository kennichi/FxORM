package data
{
import interfaces.IEntityManager;

public class ReferenceObjectBase extends SimpleObjectBase
	{
		private var _simpleObjectReference : SimpleObject;
		public function ReferenceObjectBase()
		{
			super();
		}

		[Column(name="baseReference", isReference=true)]
		public function get simpleObjectReference():SimpleObject
		{
			if (!_simpleObjectReference) _simpleObjectReference = getReference("simpleObjectReference") as SimpleObject;
			return _simpleObjectReference;
		}

		public function set simpleObjectReference(value:SimpleObject):void
		{
			_simpleObjectReference = value;
			setReference("simpleObjectReference", value)
		}

	}
}