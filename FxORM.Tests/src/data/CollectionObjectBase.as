package data
{
import interfaces.IEntityManager;

import mx.collections.ArrayCollection;

	public class CollectionObjectBase extends ReferenceObject
	{
		private var _simpleObjectsCollection : ArrayCollection;
		public function CollectionObjectBase()
		{
			super();
		}
		[Column(name="simpleObjectsCollection", isCollection=true, collectionItemType="data.SimpleObject")]
		public function get simpleObjectsCollection() : ArrayCollection
		{
			if (!_simpleObjectsCollection) _simpleObjectsCollection = getCollection("simpleObjectsCollection");
			return _simpleObjectsCollection;
		}
		public function set simpleObjectsCollection(value : ArrayCollection) : void
		{
			_simpleObjectsCollection = value;
			setCollection("simpleObjectsCollection", value);
		}
	}
}