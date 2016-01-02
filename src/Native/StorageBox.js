window.foreign = {
    'sanitize': function (record) {
        var spaces = Array.prototype.slice.call(arguments, 1);
        return spaces.reduce(function (r, space) {
            return (function () {
                r[space] ? void 0 : r[space] = {};
                return r[space];
            })();
        }, record);
    }
};
var make = function make(localRuntime) {
    return function () {
        var Taskø1 = Elm.Native.Task.make(localRuntime);
        var Utilsø1 = Elm.Native.Utils.make(localRuntime);
        var Signalø1 = Elm.Native.Signal.make(localRuntime);
        var Tuple0ø1 = (Utilsø1 || 0)['Tuple0'];
        return (function () {
            foreign.sanitize(localRuntime, 'Native', 'StorageBox');
            return localRuntime.Native.StorageBox.values ? localRuntime.Native.StorageBox.values : localRuntime.Native.StorageBox.values = {
                'storageBox': F2(function (key, defaultValue) {
                    return function () {
                        var getItemø1 = function () {
                            return function () {
                                var xø1 = localStorage.getItem(key);
                                return xø1 == null ? defaultValue : JSON.parse(xø1);
                            }.call(this);
                        };
                        var streamø1 = Signalø1.input('retrieve.' + key, getItemø1());
                        var initialø1 = getItemø1();
                        var sendø1 = function (value) {
                            return Taskø1.asyncFunction(function (callback) {
                                return (function () {
                                    localRuntime.setTimeout(function () {
                                        return !(value == defaultValue) ? (function () {
                                            localStorage.setItem(key, JSON.stringify(value));
                                            return localRuntime.notify(streamø1.id, getItemø1());
                                        })() : void 0;
                                    }, 0);
                                    return callback(Taskø1.succeed(Tuple0ø1));
                                })();
                            });
                        };
                        return (function () {
                            localRuntime.addListener([streamø1.id], window, 'storage', function () {
                                return localRuntime.notify(streamø1.id, getItemø1());
                            });
                            return {
                                'address': {
                                    'ctor': 'Address',
                                    '_0': sendø1
                                },
                                'signal': streamø1
                            };
                        })();
                    }.call(this);
                })
            };
        })();
    }.call(this);
};
foreign.sanitize(Elm, 'Native', 'StorageBox');
Elm.Native.StorageBox.make = make;