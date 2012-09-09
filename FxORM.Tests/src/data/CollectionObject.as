package data
{
import interfaces.IEntityManager;

import mx.collections.ArrayCollection;

	[Table(name="collectionObjects")]
	public class CollectionObject extends CollectionObjectBase
	{
		private var _collectionObjectsCollection : ArrayCollection;
		private var _referenceObjectsCollection : ArrayCollection;
		public function CollectionObject()
		{
			super();
		}	

		[Column(name="collectionObjectsCollection", isCollection=true, collectionItemType="data.CollectionObject")]
		public function get collectionObjectsCollection():ArrayCollection
		{
			if (!_collectionObjectsCollection) _collectionObjectsCollection = getCollection("collectionObjectsCollection");
			return _collectionObjectsCollection;
			
		}

		public function set collectionObjectsCollection(value:ArrayCollection):void
		{
			_collectionObjectsCollection = value;
			setCollection("collectionObjectsCollection", value);
		}

		[Column(name="referenceObjectsCollection", isCollection=true, collectionItemType="data.ReferenceObject")]
		public function get referenceObjectsCollection():ArrayCollection
		{
			if (!_referenceObjectsCollection) _referenceObjectsCollection = getCollection("referenceObjectsCollection", false);
			return _referenceObjectsCollection;
		}

		public function set referenceObjectsCollection(value:ArrayCollection):void
		{
			_referenceObjectsCollection = value;
			setCollection("referenceObjectsCollection", value);
		}

	}
}