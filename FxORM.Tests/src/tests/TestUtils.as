package tests
{
	import mx.collections.ArrayCollection;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.both;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.notNullValue;

	public class TestUtils
	{
		public static function assertCollection(collection : ArrayCollection, expectedLength : int, expectedType : Class) : void
		{
			assertThat(collection != null);
			assertThat(collection.source, allOf(arrayWithSize(expectedLength), everyItem(both(isA(expectedType), notNullValue()))));
		}
			
	}
}