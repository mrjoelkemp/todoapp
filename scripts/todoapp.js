// Generated by CoffeeScript 1.3.1
(function() {
  var create, getLargestId, getNewId, getNewRank, getTasksFromUI, loadTasks, store, taskListEmpty, taskToObject, tasksExist;

  $(function() {
    var textfield;
    console.log("in todoapp");
    $("#tasks").sortable();
    textfield = $("#todotext");
    return $("#todotext").keydown(function(e) {
      var enterPressed, id, isBlank, rank, text;
      enterPressed = e.keyCode === 13;
      if (enterPressed) {
        text = $("#todotext")[0].value;
        console.log("Task: " + text);
        isBlank = text === "";
        if (!isBlank) {
          $("#todotext")[0].value = "";
          id = getNewId();
          rank = getNewRank();
          return create(id, rank, text);
        }
      }
    });
  });

  loadTasks = function() {
    var ids, tasks;
    if (!tasksExist()) {
      return;
    }
    $("#taskList #title").show();
    ids = Object.keys(localStorage);
    tasks = _.map(ids, function(id) {
      var taskObj, taskString;
      taskString = localStorage.getItem(id);
      taskObj = JSON.parse(taskString);
      return taskObj;
    });
    return _.each(tasks, function(taskObj) {
      return create(taskObj.id, taskObj.rank, taskObj.text);
    });
  };

  create = function(id, rank, text) {
    var task;
    task = $("<li></li>").clone();
    task.data("id", id);
    task.data("rank", rank);
    task.html(text);
    task.appendTo("#tasks");
    return store(task);
  };

  store = function(taskJSON) {
    var id, task;
    id = taskJSON.id;
    task = JSON.stringify(taskJSON);
    return localStorage.setItem(id, task);
  };

  taskToObject = function(task) {
    var json;
    json = {
      "id": task.data("id")({
        "rank": task.data("rank"),
        "text": task.data("text")
      })
    };
    return json;
  };

  getNewId = function() {
    return getLargestId() + 1;
  };

  getLargestId = function() {
    var ids, largest, tasks;
    if (taskListEmpty) {
      return -1;
    }
    tasks = getTasksFromUI();
    ids = _.map(tasks, function(task) {
      return task.data("id");
    });
    largest = _.max(ids);
    return largest;
  };

  getNewRank = function() {
    var newRank, ranks, tasks;
    if (taskListEmpty()) {
      return 1;
    }
    tasks = getTasksFromUI();
    ranks = _.map(tasks, function(task) {
      return task.data("rank");
    });
    newRank = _.max(ranks) + 1;
    return newRank;
  };

  taskListEmpty = function() {
    var tasks;
    tasks = getTasksFromUI();
    return _.isEmpty(tasks);
  };

  getTasksFromUI = function() {
    return $("#tasks").children();
  };

  tasksExist = function() {
    var ids;
    ids = Object.keys(localStorage);
    if (!_.isEmpty(ids)) {
      return true;
    } else {
      return false;
    }
  };

}).call(this);
