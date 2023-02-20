import 'dart:async';

class Engine {
  List<DataSet> pendingDataSets = [];
  List<DataSet> completeDataSets = [];
  int numberOfClasses = 6;
  bool running = false;

  Future<List<DataSet>> run() async {
    return completeDataSets;
  }

  List<int> clonePossibilities(List<int> source) {
    List<int> target = [];
    for(var e in source) {
      target.add(e);
    }
    return target;
  }
}

class SequentialEngine extends Engine {

  @override
  Future<List<DataSet>> run() async {
    running = true;
    // reset the array
    pendingDataSets = [];
    completeDataSets = [];
    List<int> possibilities = [];

    for(var x = 0; x<numberOfClasses; x++) {
      possibilities.add(x);
    }

    for(var x = 0; x<numberOfClasses; x++) {
      var dataSet = DataSet();
      dataSet.set(0, 0, x);
      dataSet.currentX = 1;
      dataSet.currentY = 0;
      pendingDataSets.add(dataSet);
    }
    int loopcount = 300000;
    var lastOne;
    while(pendingDataSets.length > 0 && loopcount-- > 0) {
      var dataSet = pendingDataSets[0];
      var currentPossibilities = clonePossibilities(possibilities);
      currentPossibilities = dataSet.removePossibilities(currentPossibilities);
      var currentX = dataSet.currentX;
      var currentY = dataSet.currentY;
      if(currentPossibilities.length > 0) {
        dataSet.set(currentX, currentY, currentPossibilities[0]);
        dataSet.nextCell(numberOfClasses);
        lastOne = dataSet;
        if(dataSet.done) {
          pendingDataSets.remove(dataSet);
          completeDataSets.add(dataSet);
        }
      } else {
        //  no possibilities? that means this is impossible, give up
        pendingDataSets.remove(dataSet);
      }
      for(var x=1; x<currentPossibilities.length; x++) {
        var newDataSet = dataSet.clone();
        newDataSet.set(currentX, currentY, currentPossibilities[x]);
        if(newDataSet.done) {
          completeDataSets.add(newDataSet);
        } else {
          pendingDataSets.add(newDataSet);
        }
      }
      await Future.delayed(Duration.zero);
      if(!running) {
        break;
      }
    }
    return completeDataSets;
  }
}

class RandomEngine extends Engine {

}

class DataSet {
  List<List<int?>> data = [];
  int currentX = 0;
  int currentY = 0;
  bool done = false;

  nextCell(int numberOfClasses) {
    currentX++;
    if(currentX >= numberOfClasses) {
      currentY++;
      currentX = 0;
    }
    if(currentY >= numberOfClasses) {
      done = true;
    }
  }

  set(int x, int y, int newValue) {
    while(data.length <= x) {
      data.add([]);
    }
    var row = data[x];
    while(row.length <= y) {
      row.add(null);
    }
    data[x][y] = newValue;
  }

  int? get(int x, int y) {
    if(data.length <= x || data[x].length <= y) {
      return null;
    } else {
      return data[x][y];
    }
  }

  DataSet clone() {
    var newDataSet = DataSet();
    newDataSet.currentX = currentX;
    newDataSet.currentY = currentY;
    newDataSet.done = done;
    for(var x in data) {
      List<int?> newRow = [];
      newDataSet.data.add(newRow);
      for (var y in x) {
        newRow.add(y);
      }
    }
    return newDataSet;
  }

  List<int> removePossibilities(List<int> possibilties) {
    for(var x=0; x<currentX; x++) {
      var num = get(x, currentY);
      if(num != null && possibilties.contains(num)) {
        possibilties.remove(num);
      }
    }
    for(var y=0; y<currentY; y++) {
      var num = get(currentX, y);
      if(num != null && possibilties.contains(num)) {
        possibilties.remove(num);
      }
    }
    return possibilties;
  }
}