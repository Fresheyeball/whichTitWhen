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
            foreign.sanitize(localRuntime, 'Native', 'LocalStorage');
            return localRuntime.Native.LocalStorage.values ? localRuntime.Native.LocalStorage.values : localRuntime.Native.LocalStorage.values = {
                'get': F2(function (key) {
                    return Taskø1.asyncFunction(function (callback) {
                        return function () {
                            var xø1 = localStorage.getItem(key);
                            callback(xø1 == null ? Taskø1.fail('Key not found') : void 0);
                            return Taskø1.succeed(xø1);
                        }.call(this);
                    });
                }),
                'set': F2(function (key, values) {
                    return Taskø1.asyncFunction(function (callback) {
                        return (function () {
                            localStorage.setItem(key, value);
                            return callback(Taskø1.succeed(Tuple0ø1));
                        })();
                    });
                })
            };
        })();
    }.call(this);
};
foreign.sanitize(Elm, 'Native', 'LocalStorage');
Elm.Native.LocalStorage.make = make;