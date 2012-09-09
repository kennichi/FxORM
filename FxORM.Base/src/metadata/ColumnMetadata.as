package metadata
{
	[Metadata(name="Column", types="property")]
	public class ColumnMetadata
	{
		[DefaultProperty]
		public var name : String;
		public var isReference : Boolean;
		public var isCollection : Boolean;
		public var collectionItemType : String;
		public var referenceType : String;
		public var lazyLoad : Boolean = true;
		public var isCascade : Boolean;
	}
}