package heapsmod;

enum ErrorCode
{
    INFO;
    WARNING;
    ERROR;
}

enum ErrorType
{
    // INFO
    HEAPSMOD_INITIALIZED;
    HEAPSMOD_DISABLED;
    MOD_ENABLED;
    MOD_DISABLED;
    SCRIPT_INIT;
    COMPAT_CONVERT_PATH;

    // WARNING
    MOD_MISSING_META;
    MOD_MISSING_ICON;
    MOD_INCOMPATIBLE_VERSION;
    
    // ERROR
    MOD_META_PARSE_ERROR;
    MOD_DEPENDENCY_ERROR;
    MOD_MISSING_DEPENDENCIES;
    SCRIPT_ERROR;
}

/**
 * An error class for HeapsMod.
 */
class HeapsModError
{
    /**
     * The previous error given.
     */
    static var lastError:HeapsModError;

    /**
     * The error code (info, warning, error).
     */
    public var code(default, null):ErrorCode;

    /**
     * The error type.
     */
    public var type(default, null):ErrorType;

    /**
     * The error message string.
     */
    public var message(default, null):String;

    public function new() {}

    public function toString():String
    {
        return '$code: $message';
    }

    /**
     * Builds an error to be used by HeapsMod.
     * @param code The error code (info, warning, error).
     * @param type The error type.
     * @param message The error message string.
     */
    public static function get(code:ErrorCode, type:ErrorType, message:String):HeapsModError
    {
        var error:HeapsModError = lastError ?? new HeapsModError();
  
        error.code = code;
        error.type = type;
        error.message = message;

        lastError = error;

        return error;
    }
}