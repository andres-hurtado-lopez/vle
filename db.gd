extends Node

class ColOrderSorter:
    static func sort(a, b):
        if a[0] < b[0]:
            return true
        else:
            return false

func write_key(key,value):
    var f = File.new()
    f.open('user://'+key, f.WRITE)
    f.store_var(value)
    f.close()

func read_key(key):
    var f = File.new()
    f.open('user://'+key,f.READ)
    var c = f.get_var()
    f.close()
    return c

func rebuild_database(DDL):
    for table in DDL:
        self.create_table(table,DDL[table]['columns'], DDL[table]['keys'],true)

func build_missing_tables(DDL):
    for table in DDL:
        self.create_table(table,DDL[table]['columns'], DDL[table]['keys'])

func create_table(TABLE,COLUMNS,KEYS,REBUILD=false):
    var file = File.new()
    var filename = 'user://'+TABLE+'.json'

    if not file.file_exists(filename) or REBUILD == true:
        var json_data = {'data':{}, 'def':{'columns':COLUMNS,'keys':KEYS}}
        var content = JSON.print(json_data)
        file.open(filename, file.WRITE)
        file.store_string(content)
        file.close()
    else:
        return false

func select(TABLE,CONDITION,COUNT=false):
    var file = File.new()
    var filename = 'user://'+TABLE+'.json'

    if file.file_exists(filename):
        file.open(filename, file.READ)
        var content = file.get_as_text()
        var json_result = JSON.parse(content)

        if json_result.error != 0:
            return null

        var def = json_result.result['def']
        var data = json_result.result['data']

        def['keys'].sort()

        var indexcount = 0
        var rowforhash = ""

        CONDITION.sort_custom(ColOrderSorter,'sort')
        for item in CONDITION:
            if def['keys'].find(item[0]) > -1:
                indexcount += 1
                rowforhash += item[2]

        var hashname = rowforhash.md5_text()

        if indexcount == len(def['keys']) and data.has(hashname):
            return [data[hashname]]
        else:
            var result = []
            var selcol = 0
            var rowcount = 0

            for row in data:
                selcol = 0
                for column in data[row]:
                    for item in CONDITION:
                        match item[1]:
                            '==':
                                if item[0] == column and item[2] == data[row][column]:
                                    selcol += 1
                            '!=':
                                if item[0] == column and item[2] == data[row][column]:
                                    selcol += 1
                            'IS NULL':
                                if item[0] == column and data[row][column] == null:
                                    selcol += 1


                if selcol == len(CONDITION):
                    if COUNT == false:
                        result.append(data[row])
                    else:
                        rowcount += 1

            if COUNT == true:
                return rowcount
            else:
                return result

    else:
        return null

func update(TABLE,CONDITION,CHANGES):
    var file = File.new()
    var filename = 'user://'+TABLE+'.json'

    if file.file_exists(filename):
        file.open(filename, file.READ)
        var content = file.get_as_text()
        var json_result = JSON.parse(content)

        if json_result.error != 0:
            return null

        var def = json_result.result['def']
        var data = json_result.result['data']

        def['keys'].sort()

        var indexcount = 0
        var rowforhash = ""

        CONDITION.sort_custom(ColOrderSorter,'sort')
        for item in CONDITION:
            if def['keys'].find(item[0]) > -1:
                indexcount += 1
                rowforhash += item[2]

        var hashname = rowforhash.md5_text()

        if indexcount == len(def['keys']) and data.has(hashname):
            return [data[hashname]]
        else:
            var result = []
            var selcol = 0
            var changecount = 0

            for row in data:
                selcol = 0
                for column in data[row]:
                    for item in CONDITION:
                        match item[1]:
                            '==':
                                if item[0] == column and item[2] == data[row][column]:
                                    selcol += 1
                            '!=':
                                if item[0] == column and item[2] == data[row][column]:
                                    selcol += 1
                            'IS NULL':
                                if item[0] == column and data[row][column] == null:
                                    selcol += 1


                if selcol == len(CONDITION):
                    changecount += 1

                    var orow = data[row]
                    for change in CHANGES:
                        orow[change] = CHANGES[change].duplicate()

                    def['keys'].sort()
                    var hashstack = ""
                    for key in def['keys']:
                        hashstack += orow[key]

                    var newhashname = hashstack.md5_text()
                    data.erase(row)
                    data[newhashname] = orow


            json_result = { 'def':def, 'data': data }
            content = JSON.print(json_result)

            file.open(filename, file.WRITE)
            file.store_string(content)
            file.close()

            return changecount

    else:
        return null

func delete(TABLE,CONDITION):
    var file = File.new()
    var filename = 'user://'+TABLE+'.json'

    if file.file_exists(filename):
        file.open(filename, file.READ)
        var content = file.get_as_text()
        var json_result = JSON.parse(content)

        if json_result.error != 0:
            return null

        var def = json_result.result['def']
        var data = json_result.result['data']

        def['keys'].sort()

        var indexcount = 0
        var rowforhash = ""

        CONDITION.sort_custom(ColOrderSorter,'sort')
        for item in CONDITION:
            if def['keys'].find(item[0]) > -1:
                indexcount += 1
                rowforhash += item[2]

        var hashname = rowforhash.md5_text()

        if indexcount == len(def['keys']) and data.has(hashname):
            return [data[hashname]]
        else:
            var result = []
            var selcol = 0
            var changecount = 0

            for row in data:
                selcol = 0
                for column in data[row]:
                    for item in CONDITION:
                        match item[1]:
                            '==':
                                if item[0] == column and item[2] == data[row][column]:
                                    selcol += 1
                            '!=':
                                if item[0] == column and item[2] == data[row][column]:
                                    selcol += 1
                            'IS NULL':
                                if item[0] == column and data[row][column] == null:
                                    selcol += 1


                if selcol == len(CONDITION):
                    changecount += 1
                    data.erase(row)

            json_result = { 'def':def, 'data': data }
            content = JSON.print(json_result)

            file.open(filename, file.WRITE)
            file.store_string(content)
            file.close()

            return changecount

    else:
        return null

func insert(TABLE,ROW):
    var file = File.new()
    var filename = 'user://'+TABLE+'.json'

    if file.file_exists(filename):
        file.open(filename, file.READ)
        var content = file.get_as_text()
        file.close()
        var json_result = JSON.parse(content)

        if json_result.error != 0:
            return false

        var def = json_result.result['def']
        var data = json_result.result['data']

        def['keys'].sort()

        var rowforhash = ""

        for item in def['keys']:
            rowforhash += ROW[item]
        var hashdata = rowforhash.md5_text()

        var orow = {}
        for col in def['columns']:
            if ROW.has(col):
                orow[col] = ROW[col]
            else:
                orow[col] = null

        data[hashdata] = orow

        json_result = { 'def':def, 'data': data }
        content = JSON.print(json_result)

        file.open(filename, file.WRITE)
        file.store_string(content)
        file.close()

        return true

    else:
        return false
