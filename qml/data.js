var id = "placeholderid";

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
                      'mainColor TEXT, textureColor TEXT, borderColor TEXT, ' +
                      'tags TEXT)');

        var res = tx.executeSql('SELECT * FROM Collection');
        if (res.rows.length === 0) {
            Data.fillDatabase(db);
        }

        tx.executeSql('CREATE TABLE IF NOT EXISTS Domain(id TEXT, name TEXT, ' +
                      'domain TEXT, ' +
                      'ageContextPrefix TEXT, ageContextSuffix TEXT, ' +
                      'borderWidth NUMERIC, ' +
                      'textureType NUMERIC, smooth NUMERIC, ' +
                      'textureHeight NUMERIC, textureWidth NUMERIC, ' +
                      'mainColor TEXT, textureColor TEXT, borderColor TEXT)');
        res = tx.executeSql('SELECT * FROM Domain WHERE id = \'' + id + '\'');
        if (res.rows.length === 0)
            tx.executeSql('INSERT INTO Domain VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)',
                          [id, "", "", "", "", 0, 0, 0, 100, 100, "", "", ""]);
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
            'INSERT INTO Collection VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
            [item.title,
             item.origin, item.originColor,
             item.type,
             item.age, item.ageUnit,
             item.weightTotal, item.weightLeft,
             item.weightUnit,
             item.cost, item.secondaryCost,
             item.mainColor, item.textureColor, item.borderColor,
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
                  mainColor: item.mainColor,
                  textureColor: item.textureColor,
                  borderColor: item.borderColor,
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

function getRandomColors()
{
    var mainColor = "";
    var textureColor = "";
    var borderColor = "";

    var db = openDatabase();
    db.transaction(function(tx) {
        var res = tx.executeSql('SELECT mainColor, textureColor, borderColor ' +
                                'FROM Collection');
        if (res.rows.length === 0)
            return;

        var index = Math.floor(Math.random() * res.rows.length);
        var item = res.rows.item(index);
        mainColor = item.mainColor;
        textureColor = item.textureColor;
        borderColor = item.borderColor;
    });

    return [mainColor, textureColor, borderColor];
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

function setDomainValue(col, value)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('UPDATE Domain SET ' + col + ' = \'' + value + '\' ' +
                      'WHERE id = \'' + id + '\'');
    });
}

function getDomainValue(col)
{
    var item = "";
    var db = openDatabase();
    db.transaction(function(tx) {
        var res = tx.executeSql('SELECT ' + col + ' FROM Domain ' +
                                'WHERE id = \'' + id + '\'');
        if (res.rows.length === 0 )
            return;
        item = res.rows.item(0);
    });
    return item;
}

function setDomainName(name)
{
    setDomainValue("name", name);
}

function getDomainName()
{
    var item = getDomainValue("name");
    return item === "" ? "" : item.name;
}

function setDomainType(domain)
{
    setDomainValue("domain", domain);
}

function getDomainType(domain)
{
    var item = getDomainValue("domain");
    return item === "" ? "" : item.domain;
}

function setDomainAgeContextPrefix(prefix)
{
    setDomainValue("ageContextPrefix", prefix);
}

function getDomainAgeContextPrefix()
{
    var item = getDomainValue("ageContextPrefix");
    return item === "" ? "" : item.ageContextPrefix;
}

function setDomainAgeContextSuffix(suffix)
{
    setDomainValue("ageContextSuffix", suffix);
}

function getDomainAgeContextSuffix()
{
    var item = getDomainValue("ageContextSuffix");
    return item === "" ? "" : item.ageContextSuffix;
}

function formatDomainAgeContext(prefix, suffix)
{
    return (prefix + " %1 %2 " + suffix).trim();
}

function setDomainBorderWidth(borderWidth)
{
    setDomainValue("borderWidth", borderWidth);
}

function getDomainBorderWidth()
{
    var item = getDomainValue("borderWidth");
    return item === "" ? 0 : item.borderWidth;
}

function setDomainTextureType(type)
{
    setDomainValue("textureType", type);
}

function getDomainTextureType()
{
    var item = getDomainValue("textureType");
    return item === "" ? 0 /* No Texture */ : item.textureType;
}

function setDomainTextureSmooth(isSmooth)
{
    setDomainValue("smooth", isSmooth ? 1 : 0);
}

function getDomainTextureSmooth()
{
    var item = getDomainValue("smooth");
    return item !== "" && item.smooth !== 0;
}

function setDomainTextureHeight(height)
{
    setDomainValue("textureHeight", height);
}

function getDomainTextureHeight()
{
    var item = getDomainValue("textureHeight");
    return item === "" ? 100 : item.textureHeight;
}

function setDomainTextureWidth(width)
{
    setDomainValue("textureWidth", width);
}

function getDomainTextureWidth()
{
    var item = getDomainValue("textureWidth");
    return item === "" ? 100 : item.textureWidth;
}

function setDomainMainColor(color)
{
    setDomainValue("mainColor", color);
}

function getDomainMainColor()
{
    var item = getDomainValue("mainColor");
    return item === "" ? "" : item.mainColor;
}

function setDomainTextureColor(color)
{
    setDomainValue("textureColor", color);
}

function getDomainTextureColor()
{
    var item = getDomainValue("textureColor");
    return item === "" ? "" : item.textureColor;
}

function setDomainBorderColor(color)
{
    setDomainValue("borderColor", color);
}

function getDomainBorderColor()
{
    var item = getDomainValue("borderColor");
    return item === "" ? "" : item.borderColor;
}