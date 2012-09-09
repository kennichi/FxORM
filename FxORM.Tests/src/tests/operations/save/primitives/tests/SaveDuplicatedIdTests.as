package tests.operations.save.primitives.tests {
import data.peopleAndCompanies.Company;

import org.flexunit.asserts.assertEquals;
import tests.queries.tests.BaseBusinessTests;

public class SaveDuplicatedIdTests extends BaseBusinessTests {
    [Test]
    public function save_changed_duplicatedId_without_clearing_cache_should_replace_prev_value() {
        var company1 : Company = company("htc", person("john").build());
        company1.idField = "htc";
        company1.save();
        var company2 : Company = company("samsung", person("jack").build());
        company2.idField = "htc";
        company2.save();
        assertEquals(company1.objectId, company2.objectId);
        var companyById : Company = Company(FxORM.instance.entityManager.getObject(company1.objectId));
        assertEquals("jack", companyById.manager.name);
        assertEquals("samsung", companyById.name);
        var companyByBEId : Company = Company(FxORM.instance.entityManager.getByDuplicatedId("htc", Company));
        assertEquals("jack", companyByBEId.manager.name);
        assertEquals("samsung", companyByBEId.name);
    }
}
}
