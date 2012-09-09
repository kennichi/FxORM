/**
 * Created with IntelliJ IDEA.
 * User: msakharova
 * Date: 23/07/2012
 * Time: 09:07
 * To change this template use File | Settings | File Templates.
 */
package tests.beIds {

import cache.CacheManager;

import data.peopleAndCompanies.Company;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;

import tests.queries.tests.BaseBusinessTests;

public class BEIdsTests extends BaseBusinessTests {
    [Test]
    public function test2BEInstancesSavedToSame() : void {
        save2CompaniesWithSameBeId("htc");

        cleanCache();

        var companies:Array = entityManager.findAll(Company);
        assertEquals(1, companies.length);

        assertEquals("John", companies[0].manager.name);

    }

    private function save2CompaniesWithSameBeId(beId : String):void {
        var company:Company = new Company();
        company.manager = person("Harry").build();
        company.idField = beId;
        company.save();

        company = new Company();
        company.manager = person("John").build();
        company.idField = beId;
        company.save();

        CacheManager.instance.reset();
    }

    [Test]
    public function testBEInstanceRetrieve() : void {
        save2CompaniesWithSameBeId("samsung");
        cleanCache();
        var companyById:Company = Company(entityManager.getByDuplicatedId("samsung", Company));
        assertNotNull(companyById);
        assertEquals("John", companyById.manager.name);
    }
}
}
