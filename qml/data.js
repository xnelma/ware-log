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

        var rs = tx.executeSql('SELECT * FROM Collection');
        if (rs.rows.length === 0) {
            Data.fillDatabase(db);
        }
    });

    return db;
}

function fillDatabase(db)
{
    var data = parseSampleData();

    db.transaction(
        function(tx) {
            var res = tx.executeSql('SELECT * FROM Collection');
            if (res.rows.length !== 0)
                return;

            data.forEach(function(item) {
                tx.executeSql(
                    'INSERT INTO Collection VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                    [item.title,
                     item.origin, item.originColor,
                     item.type,
                     item.age, item.ageUnit,
                     item.weightTotal, item.weightLeft,
                     item.weightUnit,
                     item.cost, item.secondaryCost,
                     item.primaryColor, item.secondaryColor,
                     tagStr(item.tags)]
                );
            });
        }
    );
}

function tagStr(tags)
{
    var tagStr = "";
    tags.forEach(function (s) {
        tagStr = tagStr + s + "|";
    });

    if (tagStr.length > 0 && tagStr[tagStr.length - 1] === "|")
        tagStr = tagStr.substring(0, tagStr.length - 1);

    return tagStr;
}
