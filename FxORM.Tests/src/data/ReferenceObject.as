package data
{
import interfaces.IEntityManager;

[Table(name="referenceObjects")]
	public class ReferenceObject extends ReferenceObjectBase
	{
		private var _referenceObjectReference : ReferenceObject;
		private var _anotherReferenceObjectReference : ReferenceObjectBase;
		private var _simpleValueField : String;
		public function ReferenceObject()
		{
			super();
		}
		
		[Column(name="referenceObject", isReference=true)]
		public function get referenceObjectReference():ReferenceObject
		{
			if (!_referenceObjectReference)
				_referenceObjectReference = getReference("referenceObjectReference") as ReferenceObject;
			return _referenceObjectReference;
		}

		public function set referenceObjectReference(value:ReferenceObject):void
		{
			_referenceObjectReference = value;
			setReference("referenceObjectReference", value);
		}

		[Column(name="simpleValueField")]
		public function get simpleValueField():String
		{
			return _simpleValueField;
		}

		public function set simpleValueField(value:String):void
		{
			_simpleValueField = value;
			setPrimitiveValue("simpleValueField", value);
		}

		[Column(name="anotherReferenceObject", isReference=true, referenceType="data.AnotherReferenceObject")]
		public function get anotherReferenceObjectReference():ReferenceObjectBase
		{
			if (!_anotherReferenceObjectReference)
				_anotherReferenceObjectReference = getReference("anotherReferenceObjectReference") as ReferenceObjectBase;
			return _anotherReferenceObjectReference;
		}

		public function set anotherReferenceObjectReference(value:ReferenceObjectBase):void
		{
			_anotherReferenceObjectReference = value;
			setReference("anotherReferenceObjectReference", value);
		}

	}
}