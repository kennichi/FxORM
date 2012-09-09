package data
{
import interfaces.IEntityManager;

[Table(name="otherReferences")]
	public class AnotherReferenceObject extends ReferenceObjectBase
	{
		private var _date : Date;
		public function AnotherReferenceObject()
		{
			super();
		}
		private var _reference : SimpleObject;

		[Column(name="date")]
		public function get date():Date
		{
			return _date;
		}

		public function set date(value:Date):void
		{
			_date = value;
			setPrimitiveValue("date", value);
		}

		[Column(name="reference", isReference=true, lazyLoad=true)]
		public function get reference():SimpleObject
		{
			if (!_reference) _reference = getReference("reference") as SimpleObject;
			return _reference;
		}

		public function set reference(value:SimpleObject):void
		{
			_reference = value;
			setReference("reference", value)
		}

	}
}