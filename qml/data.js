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

        var res = tx.executeSql('SELECT * FROM Collection');
        if (res.rows.length === 0) {
            Data.fillDatabase(db);
        }
    });

    return db;
}

function insertItem(item, tx)
{
    switch (arguments.length) {
    case 1: {
        var db = openDatabase();
        db.transaction(function(tx) {
            insertItem(item, tx);
        });
        break;
    }
    case 2: {
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
        break;
    }
    default:
        break;
    }
}

function fillDatabase(db)
{
    var data = parseSampleData();

    db.transaction(function(tx) {
        var res = tx.executeSql('SELECT * FROM Collection');
        if (res.rows.length !== 0)
            return;

        data.forEach(function(item) {
            insertItem(item, tx);
        });
    });
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

function get(model)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        var res = tx.executeSql('SELECT * FROM Collection');
        for (var i = 0; i < res.rows.length; i++) {
            var item = res.rows.item(i);
            model.append(
                { title: item.title,
                  origin: item.origin, originColor: item.originColor,
                  type: item.type,
                  age: item.age, ageUnit: item.ageUnit,
                  weightTotal: item.weightTotal,
                  weightLeft: item.weightLeft,
                  weightUnit: item.weightUnit,
                  cost: item.cost, secondaryCost: item.secondaryCost,
                  primaryColor: item.primaryColor,
                  secondaryColor: item.secondaryColor,
                  tagStr: item.tags
                  // TODO Why can't I directly add a list of string as
                  // property of the list element? If I use the property
                  // as a list in the delegate, it is empty, or the entries
                  // are empty, depending on the type (list<string> or var).
                });
        }
    });
}

function tagList(tagStr)
{
    if (tagStr.length === 0)
        // split() would otherwise produce [""]
        return [];
    var tags = tagStr.split("|");
    return tags;
}

function deleteItem(title)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Collection WHERE title = \'' + title + '\'');
    });
}

function updateWeight(title, weight)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('UPDATE Collection SET weightLeft = ' + weight
                      + ' WHERE title = \'' + title + '\'');
    });
}

function updateCost(title, cost)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('UPDATE Collection SET secondaryCost = ' + cost
                      + ' WHERE title = \'' + title + '\'');
    });
}

function getAllTags()
{
    const allTags = [];
    var db = openDatabase();
    db.transaction(function(tx) {
        var res = tx.executeSql('SELECT tags FROM Collection');
        for (var i = 0; i < res.rows.length; i++) {
            var itemTags = tagList(res.rows.item(i).tags);
            for (var j = 0; j < itemTags.length; j++) {
                if (!allTags.includes(itemTags[j]))
                    allTags.push(itemTags[j]);
            }
        }
    });
    return allTags;
}

function getAllTypes()
{
    const allTypes = [];
    var db = openDatabase();
    db.transaction(function(tx) {
        var res = tx.executeSql('SELECT type FROM Collection');
        for (var i = 0; i < res.rows.length; i++) {
            var itemType = res.rows.item(i).type;
            if (!allTypes.includes(itemType))
                allTypes.push(itemType);
        }
    });
    return allTypes;
}
