function DashboardModule(settings)  {
  var DEFAULT_SETTINGS = [
        {key: "url", type: "string", validation: /^[\w\/.?=]+$/ },
        {key: "updateInterval", type: "number", validation: /^[1-9][0-9]*$/, defaultValue: 30}
      ],
      cache = {};

  settings = (function(userDefinedSettings, defaultSettings) {
    var settings = {};

    for (var i = -1, length = defaultSettings.length; ++i < length;) {
      var setting = defaultSettings[i],
          key = setting.key,
          type = setting.type,
          validation = setting.validation,
          defaultValue = setting.defaultValue,
          value = userDefinedSettings[key],
          isValid;

      if (value === undefined && defaultValue !== undefined) {
        settings[key] = defaultValue;
        continue;
      }

      switch (type) {
        case "string":
          isValid = value.search(validation) > -1 ? true : false;
          break;

        case "number":
          isValid = String(parseInt(value, 10)).search(validation) > -1 ? true : false;

          break;

        default:
          continue;
      }

      if (!isValid) {
        throw ["dashboardModule(): settings.", key, " is invalid"].join("");
      }

      settings[key] = value;
    }

    return settings;
  })(settings, DEFAULT_SETTINGS);

  /**
   * Set/get state values.
   *
   * If only key param is set, then function is a getter, or else it is a setter.
   *
   * .cache(key, value)
   * key - string - key
   * value - mixed - (optional) value
   */
  this.cache = function(key, value) {
    if (value === undefined) {
      return cache[key];
    } else if (typeof key === "string" && key.length > 0) {
      cache[key] = value;
    } else {
      throw ".cache(): key is not valid";
    }
  };

  /**
   * Get settings.
   *
   * If the optional key param is set, then that particular setting is returned, or all settings are
   * returned as a key-value mapping.
   *
   * .settings(key)
   * key - string - (optional) setting
   *
   * Return: mixed
   */
  this.settings = function(key) {
    if (typeof key === "string") {
      return settings[key];
    }
    return $.extend({}, settings);
  };
}

/**
 * Create a dashboard module.
 *
 * The module is updated periodically.
 *
 * .init(cssSelector, complete)
 * cssSelector - string - DOM node to render the module
 * complete - function - (optional) callback function
 */
DashboardModule.prototype.init = function(cssSelector, complete) {
  var parentNode = $(cssSelector).get(0);
  if (parentNode) {
    this.render(parentNode, complete);
  }
};

/**
 * Renders the module layout.
 *
 * Layout is redrawn periodically.
 *
 * .render(parentNode, complete)
 * parentNode - object - DOM node
 * complete - function - (optional) callback function
 */
DashboardModule.prototype.render = function(parentNode, complete) {
  var _DASHBOARDMODULE_ = this,
    $parentNode = $(parentNode),
    updateTimerId = _DASHBOARDMODULE_.cache("updateTimerId");

  if (typeof updateTimerId === "number") {
    clearInterval(updateTimerId);
  }

  // Helper function to update status
  var updateStatus = function() {
    var statusComplete = function(data) {
      $parentNode
        .empty()
        .html(data);
      if (typeof complete === "function") {
        complete();
      }
    };
    _DASHBOARDMODULE_.status(statusComplete);
  };
  updateTimerId = setInterval(updateStatus, this.settings("updateInterval") * 1000);
  updateStatus();

  _DASHBOARDMODULE_.cache("updateTimerId", updateTimerId);
};

/**
 * Retrieve data.
 *
 * .status(complete)
 * complete - function - function to call after data is retrieved
 *
 * complete function:
 * data - object - key-value mapping
 */
DashboardModule.prototype.status = function(complete) {
  $.ajax({
    dataType: "html",
    url: this.settings("url"),
    success: function(data) {
      complete(data);
    }
  });
};
