function parseSampleData()
{
    var path = "assets/sample_data.json";
    if (!FileUtils.existsFile(path)) {
        console.log("File " + path + " not found");
        return "";
    }

    var json = FileUtils.readFile(Qt.resolvedUrl("../" + path));
    var obj = JSON.parse(json);
    if (!obj) {
        console.log("JSON data " + json + " could not be parsed");
        return "";
    }

    return obj.collection;
}

function openDatabase()
{
    var db = LocalStorage.openDatabaseSync("WareLogDB",
                                           "1.0",
                                           "The database used by WareLog.",
                                           10e4);

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS Collection(title TEXT, ' +
                      'origin TEXT, originColor TEXT, ' +
                      'type TEXT, ' +
                      'age NUMERIC, ageUnit TEXT, ' +
                      'weightTotal NUMERIC, weightLeft NUMERIC, ' +
                      'weightUnit TEXT, ' +
                      'cost NUMERIC, secondaryCost NUMERIC, ' +
                      'primaryColor TEXT, secondaryColor TEXT, ' +
                      'tags TEXT)');

        // TODO fill database with sample data
    });

    return db;
}
