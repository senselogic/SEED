module seed;

// -- IMPORTS

import core.stdc.stdlib : exit;
import std.ascii : isDigit, isLower, isUpper;
import std.conv : to;
import std.file : dirEntries, exists, mkdirRecurse, read, readText, remove, rmdir, thisExePath, write, SpanMode;
import std.path : dirName;
import std.stdio : writeln;
import std.string : capitalize, endsWith, indexOf, join, lastIndexOf, replace, split, startsWith, strip, stripRight, toLower, toUpper;
import std.uni : isAlpha;

// -- TYPES

enum VERBOSITY
{
    Error,
    Warning,
    Activity,
    Action,
    Operation,
    Information,
    Debug
}

// -- VARIABLES

VERBOSITY
    Verbosity = VERBOSITY.Debug;

// -- FUNCTIONS

void SetVerbosity(
    VERBOSITY verbosity
    )
{
    Verbosity = verbosity;
}

// ~~

bool HasVerbosity(
    VERBOSITY verbosity
    )
{
    return Verbosity >= verbosity;
}

// ~~

void PrintWarning(
    string message
    )
{
    writeln( "*** WARNING : ", message );
}

// ~~

void PrintError(
    string message
    )
{
    writeln( "*** ERROR : ", message );
}

// ~~

void Abort(
    string message
    )
{
    PrintError( message );

    exit( -1 );
}

// ~~

void Abort(
    string message,
    Exception exception
    )
{
    PrintError( message );
    PrintError( exception.msg );

    exit( -1 );
}

// ~~

bool IsLinux(
    )
{
    version ( linux )
    {
        return true;
    }
    else
    {
        return false;
    }
}

// ~~

bool IsMacOs(
    )
{
    version ( OSX )
    {
        return true;
    }
    else
    {
        return false;
    }
}

// ~~

bool IsWindows(
    )
{
    version ( Windows )
    {
        return true;
    }
    else
    {
        return false;
    }
}

// ~~

bool IsAlphabeticalCharacter(
    char character
    )
{
    return
        ( character >= 'a' && character <= 'z' )
        || ( character >= 'A' && character <= 'Z' );
}

// ~~

bool IsIdentifierCharacter(
    char character
    )
{
    return
        ( character >= 'a' && character <= 'z' )
        || ( character >= 'A' && character <= 'Z' )
        || ( character >= '0' && character <= '9' )
        || character == '_';
}

// ~~

bool IsDecimalCharacter(
    char character
    )
{
    return ( character >= '0' && character <= '9' );
}

// ~~

bool IsDecimalCharacter(
    dchar character
    )
{
    return ( character >= '0' && character <= '9' );
}

// ~~

bool IsNumberCharacter(
    char character
    )
{
    return
        ( character >= '0' && character <= '9' )
        || character == '.'
        || character == '-'
        || character == 'e'
        || character == 'E';
}

// ~~

bool IsSpaceCharacter(
    dchar character
    )
{
    return
        character == dchar( ' ' )
        || character == dchar( '\t' )
        || character == dchar( 0xA0 );
}

// ~~

bool IsDigitCharacter(
    dchar character
    )
{
    return
        character >= '0'
        && character <= '9';
}

// ~~

bool IsVowelCharacter(
    char character
    )
{
    return "aeiouy".indexOf( character ) >= 0;
}

// ~~

bool IsConsonantCharacter(
    char character
    )
{
    return "bcdfghjklmnpqrstvwx".indexOf( character ) >= 0;
}

// ~~

bool StartsByVowel(
    string text
    )
{
    return
        text != ""
        && IsVowelCharacter( text[ 0 ] );
}

// ~~

bool StartsByConsonant(
    string text
    )
{
    return
        text != ""
        && IsConsonantCharacter( text[ 0 ] );
}

// ~~

bool EndsByVowel(
    string text
    )
{
    return
        text != ""
        && IsVowelCharacter( text[ $ - 1 ] );
}

// ~~

bool EndsByConsonant(
    string text
    )
{
    return
        text != ""
        && IsConsonantCharacter( text[ $ - 1 ] );
}

// ~~

string GetBooleanText(
    bool boolean
    )
{
    if ( boolean )
    {
        return "true";
    }
    else
    {
        return "false";
    }
}

// ~~

bool IsNatural(
    string text
    )
{
    if ( text.length > 0 )
    {
        foreach ( character; text )
        {
            if ( character < '0'
                 || character > '9' )
            {
                return false;
            }
        }

        return true;
    }
    else
    {
        return false;
    }
}

// ~~

bool IsInteger(
    string text
    )
{
    if ( text.length > 0
         && text[ 0 ] == '-' )
    {
        text = text[ 1 .. $ ];
    }

    return IsNatural( text );
}

// ~~

ulong GetNatural(
    string text
    )
{
    try
    {
        return text.to!ulong();
    }
    catch ( Exception exception )
    {
        Abort( "Invalid natural : " ~ text, exception );
    }

    return 0;
}

// ~~

long GetInteger(
    string text
    )
{
    try
    {
        return text.to!long();
    }
    catch ( Exception exception )
    {
        Abort( "Invalid integer : " ~ text, exception );
    }

    return 0;
}

// ~~

double GetReal(
    long integer
    )
{
    return integer.to!double();
}

// ~~

double GetReal(
    string text
    )
{
    try
    {
        return text.to!double();
    }
    catch ( Exception exception )
    {
        Abort( "Invalid real : " ~ text, exception );
    }

    return 0.0;
}

// ~~

bool ContainsText(
    string text,
    string searched_text
    )
{
    return text.indexOf( searched_text ) >= 0;
}

// ~~

bool HasPrefix(
    string text,
    string prefix
    )
{
    return text.startsWith( prefix );
}

// ~~

bool HasSuffix(
    string text,
    string suffix
    )
{
    return text.endsWith( suffix );
}

// ~~

string GetPrefix(
    string text,
    string separator
    )
{
    return text.split( separator )[ 0 ];
}

// ~~

string GetSuffix(
    string text,
    string separator
    )
{
    return text.split( separator )[ $ - 1 ];
}

// ~~

string AddPrefix(
    string text,
    string prefix
    )
{
    return prefix ~ text;
}

// ~~

string AddSuffix(
    string text,
    string suffix
    )
{
    return text ~ suffix;
}

// ~~

string RemovePrefix(
    string text,
    string prefix
    )
{
    if ( text.startsWith( prefix ) )
    {
        return text[ prefix.length .. $ ];
    }
    else
    {
        return text;
    }
}

// ~~

string RemoveSuffix(
    string text,
    string suffix
    )
{
    if ( text.endsWith( suffix ) )
    {
        return text[ 0 .. $ - suffix.length ];
    }
    else
    {
        return text;
    }
}

// ~~

string ReplacePrefix(
    string text,
    string old_prefix,
    string new_prefix
    )
{
    if ( text.startsWith( old_prefix ) )
    {
        return new_prefix ~ text[ old_prefix.length .. $ ];
    }
    else
    {
        return text;
    }
}

// ~~

string ReplaceSuffix(
    string text,
    string old_suffix,
    string new_suffix
    )
{
    if ( text.endsWith( old_suffix ) )
    {
        return text[ 0 .. $ - old_suffix.length ] ~ new_suffix;
    }
    else
    {
        return text;
    }
}

// ~~

string ReplaceText(
    string text,
    string old_text,
    string new_text
    )
{
    return text.replace( old_text, new_text );
}

// ~~

string GetStrippedText(
    string text
    )
{
    dstring
        unicode_text;

    unicode_text = text.to!dstring();

    while ( unicode_text.length > 0
            && IsSpaceCharacter( unicode_text[ 0 ] ) )
    {
        unicode_text = unicode_text[ 1 .. $ ];
    }

    while ( unicode_text.length > 0
            && IsSpaceCharacter( unicode_text[ $ - 1 ] ) )
    {
        unicode_text = unicode_text[ 0 .. $ - 1 ];
    }

    return unicode_text.to!string();
}

// ~~

string GetLeftStrippedText(
    string text
    )
{
    dstring
        unicode_text;

    unicode_text = text.to!dstring();

    while ( unicode_text.length > 0
            && IsSpaceCharacter( unicode_text[ 0 ] ) )
    {
        unicode_text = unicode_text[ 1 .. $ ];
    }

    return unicode_text.to!string();
}

// ~~

string GetRightStrippedText(
    string text
    )
{
    dstring
        unicode_text;

    unicode_text = text.to!dstring();

    while ( unicode_text.length > 0
            && IsSpaceCharacter( unicode_text[ $ - 1 ] ) )
    {
        unicode_text = unicode_text[ 0 .. $ - 1 ];
    }

    return unicode_text.to!string();
}

// ~~

dstring GetUnaccentedCharacter(
    dchar character,
    string language_code = "",
    bool next_character_is_lower_case = false
    )
{
    switch ( character )
    {
        case 'á', 'à', 'â' :
        {
            return "a";
        }
        case 'ä' :
        {
            if ( language_code == "de" )
            {
                return "ae";
            }
            else
            {
                return "a";
            }
        }
        case 'é', 'è', 'ê', 'ë' :
        {
            return "e";
        }
        case 'í', 'ì', 'î', 'ï' :
        {
            return "i";
        }
        case 'ó', 'ò', 'ô' :
        {
            return "o";
        }
        case 'ö' :
        {
            if ( language_code == "de" )
            {
                return "oe";
            }
            else
            {
                return "o";
            }
        }
        case 'œ' :
        {
            return "oe";
        }
        case 'ú', 'ù', 'û' :
        {
            return "u";
        }
        case 'ü' :
        {
            if ( language_code == "de" )
            {
                return "ue";
            }
            else
            {
                return "u";
            }
        }
        case 'ç' :
        {
            return "c";
        }
        case 'ñ' :
        {
            return "n";
        }
        case 'ß' :
        {
            return "ss";
        }
        case 'Á', 'À', 'Â' :
        {
            return "A";
        }
        case 'Ä' :
        {
            if ( language_code == "de" )
            {
                if ( next_character_is_lower_case )
                {
                    return "Ae";
                }
                else
                {
                    return "AE";
                }
            }
            else
            {
                return "A";
            }
        }
        case 'É', 'È', 'Ê', 'Ë' :
        {
            return "E";
        }
        case 'Í', 'Ì', 'Î' :
        {
            return "I";
        }
        case 'Ï' :
        {
            return "I";
        }
        case 'Ó', 'Ò', 'Ô' :
        {
            return "O";
        }
        case 'Ö' :
        {
            if ( language_code == "de" )
            {
                if ( next_character_is_lower_case )
                {
                    return "Oe";
                }
                else
                {
                    return "OE";
                }
            }
            else
            {
                return "O";
            }
        }
        case 'Œ' :
        {
            return "Oe";
        }
        case 'Ú', 'Ù', 'Û' :
        {
            return "U";
        }
        case 'Ü' :
        {
            if ( language_code == "de" )
            {
                if ( next_character_is_lower_case )
                {
                    return "Ue";
                }
                else
                {
                    return "UE";
                }
            }
            else
            {
                return "U";
            }
        }
        case 'Ç' :
        {
            return "C";
        }
        case 'Ñ' :
        {
            return "N";
        }
        case 'ẞ' :
        {
            if ( next_character_is_lower_case )
            {
                return "Ss";
            }
            else
            {
                return "SS";
            }
        }
        default :
        {
            return character.to!dstring();
        }
    }
}

// ~~

string GetUnaccentedText(
    string text,
    string language_code = ""
    )
{
    dstring
        unaccented_text,
        unicode_text;

    unicode_text = text.to!dstring();

    foreach ( character; unicode_text )
    {
        unaccented_text ~= GetUnaccentedCharacter( character, language_code );
    }

    return unaccented_text.to!string();
}

// ~~

string GetMinorCaseText(
    string text
    )
{
    dstring
        unicode_text;

    if ( text == "" )
    {
        return "";
    }
    else
    {
        unicode_text = text.to!dstring();

        return ( unicode_text[ 0 .. 1 ].toLower() ~ unicode_text[ 1 .. $ ] ).to!string();
    }
}

// ~~

string GetMajorCaseText(
    string text
    )
{
    dstring
        unicode_text;

    if ( text == "" )
    {
        return "";
    }
    else
    {
        unicode_text = text.to!dstring();

        return ( unicode_text[ 0 .. 1 ].capitalize() ~ unicode_text[ 1 .. $ ] ).to!string();
    }
}

// ~~

string GetLowerCaseText(
    string text
    )
{
    return text.toLower();
}

// ~~

string GetUpperCaseText(
    string text
    )
{
    return text.toUpper();
}

// ~~

string GetSpacedText(
    string text
    )
{
    foreach ( character; [ '\t', '_', '-', ',', ';', ':', '.', '!', '?' ] )
    {
        text = text.replace( character, ' ' );
    }

    while ( text.indexOf( "  " ) >= 0 )
    {
        text = text.replace( "  ", " " );
    }

    return text;
}

// ~~

string GetPascalCaseText(
    string text
    )
{
    string[]
        word_array;

    word_array = text.GetSpacedText().strip().split( ' ' );

    foreach ( ref word; word_array )
    {
        word = word.GetMajorCaseText();
    }

    return word_array.join( "" );
}

// ~~

string GetCamelCaseText(
    string text
    )
{
    return text.GetPascalCaseText().GetMinorCaseText();
}

// ~~

string GetSnakeCaseText(
    string text
    )
{
    dchar
        character,
        next_character,
        prior_character;
    long
        character_index;
    dstring
        snake_case_text,
        unicode_text;

    unicode_text = text.GetSpacedText().strip().to!dstring();

    snake_case_text = "";
    prior_character = 0;

    for ( character_index = 0;
          character_index < unicode_text.length;
          ++character_index )
    {
        character = unicode_text[ character_index ];

        if ( character_index + 1 < unicode_text.length )
        {
            next_character = unicode_text[ character_index + 1 ];
        }
        else
        {
            next_character = 0;
        }

        if ( ( prior_character.isLower()
               && ( character.isUpper()
                    || character.isDigit() ) )
             || ( prior_character.isDigit()
                  && ( character.isLower()
                       || character.isUpper() ) )
             || ( prior_character.isUpper()
                  && character.isUpper()
                  && next_character.isLower() ) )
        {
            snake_case_text ~= '_';
        }

        if ( character == ' '
             && !snake_case_text.endsWith( '_' ) )
        {
            character = '_';
        }

        snake_case_text ~= character;
        prior_character = character;
    }

    return snake_case_text.to!string().toLower();
}

// ~~

string GetKebabCaseText(
    string text
    )
{
    return GetSnakeCaseText( text ).replace( '_', '-' );
}

// ~~

string GetSlugCaseText(
    string text,
    string language_code = ""
    )
{
    dstring
        slug_case_text,
        unicode_text;

    unicode_text = text.GetUnaccentedText().GetSpacedText().strip().to!dstring();

    foreach ( character; unicode_text )
    {
        if ( character.isAlpha() )
        {
            slug_case_text ~= character.toLower();
        }
        else if ( character >= '0'
                  && character <= '9' )
        {
            if ( slug_case_text != ""
                 && !slug_case_text.endsWith( '-' )
                 && !IsDecimalCharacter( slug_case_text[ $ - 1 ] ) )
            {
                slug_case_text ~= '-';
            }

            slug_case_text ~= character;
        }
        else
        {
            if ( !slug_case_text.endsWith( '-' ) )
            {
                slug_case_text ~= '-';
            }
        }
    }

    while ( slug_case_text.endsWith( '-' ) )
    {
        slug_case_text = slug_case_text[ 0 .. $ - 1 ];
    }

    return slug_case_text.to!string();
}

// ~~

string GetSearchCaseText(
    string text,
    string language_code = ""
    )
{
    return GetSlugCaseText( text, language_code ).replace( '-', ' ' );
}

// ~~

string GetFileCaseText(
    string text
    )
{
    return GetSlugCaseText( text ).replace( '-', '_' );
}

// ~~

string GetBasilText(
    string text
    )
{
    return
        text
            .replace( "\\", "\\\\" )
            .replace( "~", "\\~" )
            .replace( "^", "\\^" )
            .replace( "{", "\\{" )
            .replace( "}", "\\}" )
            .replace( "\n", "\\n" )
            .replace( "\r", "\\r" )
            .replace( "\t", "\\t" )
            .ReplacePrefix( "#", "\\#" )
            .ReplacePrefix( "%", "\\%" )
            .ReplacePrefix( " ", "^" )
            .ReplaceSuffix( " ", "^" );
}

// ~~

string GetCsvText(
    string text
    )
{
    if ( text.indexOf( '"' ) >= 0
         || text.indexOf( ',' ) >= 0
         || text.indexOf( '\r' ) >= 0
         || text.indexOf( '\n' ) >= 0 )
    {
        return "\"" ~ text.replace( "\"", "\"\"" ) ~ "\"";
    }
    else
    {
        return text;
    }
}

// ~~

string GetJsonText(
    string text
    )
{
    return
        "\""
        ~ text
            .replace( "\\", "\\\\" )
            .replace( "\n", "\\n" )
            .replace( "\r", "\\r" )
            .replace( "\t", "\\t" )
            .replace( "\"", "\\\"" )
        ~ "\"";
}

// ~~

string GetSqlText(
    string text
    )
{
    return
        "\""
        ~ text
            .replace( "\\", "\\\\" )
            .replace( "\n", "\\n" )
            .replace( "\r", "\\r" )
            .replace( "\t", "\\t" )
            .replace( "\"", "\\\"" )
            .replace( "'", "\\'" )
        ~ "\"";
}

// ~~

string GetExecutablePath(
    string file_name
    )
{
    return dirName( thisExePath() ) ~ "/" ~ file_name;
}



// ~~

string GetLogicalPath(
    string path
    )
{
    return path.replace( '\\', '/' );
}

// ~~

string GetFolderPath(
    string file_path
    )
{
    long
        slash_character_index;

    slash_character_index = file_path.GetLogicalPath().lastIndexOf( '/' );

    if ( slash_character_index >= 0 )
    {
        return file_path[ 0 .. slash_character_index + 1 ];
    }
    else
    {
        return "";
    }
}

// ~~

string GetFileName(
    string file_path
    )
{
    long
        slash_character_index;

    slash_character_index = file_path.GetLogicalPath().lastIndexOf( '/' );

    if ( slash_character_index >= 0 )
    {
        return file_path[ slash_character_index + 1 .. $ ];
    }
    else
    {
        return file_path;
    }
}

// ~~

string GetFileLabel(
    string file_path
    )
{
    long
        dot_character_index;
    string
        file_name;

    file_name = file_path.GetFileName();
    dot_character_index = file_name.lastIndexOf( '.' );

    if ( dot_character_index >= 0 )
    {
        return file_name[ 0 .. dot_character_index ];
    }
    else
    {
        return file_name;
    }
}

// ~~

string GetFileExtension(
    string file_path
    )
{
    long
        dot_character_index;
    string
        file_name;

    file_name = file_path.GetFileName();
    dot_character_index = file_name.lastIndexOf( '.' );

    if ( dot_character_index >= 0 )
    {
        return file_name[ dot_character_index .. $ ];
    }
    else
    {
        return "";
    }
}

// ~~

bool IsEmptyFolder(
    string folder_path
    )
{
    bool
        it_is_empty_folder;

    try
    {
        it_is_empty_folder = true;

        foreach ( folder_entry; dirEntries( folder_path, SpanMode.shallow ) )
        {
            it_is_empty_folder = false;

            break;
        }
    }
    catch ( Exception exception )
    {
        Abort( "Can't read folder : " ~ folder_path, exception );
    }

    return it_is_empty_folder;
}

// ~~

void CreateFolder(
    string folder_path
    )
{
    if ( folder_path != ""
         && folder_path != "/"
         && !folder_path.exists() )
    {
        if ( HasVerbosity( VERBOSITY.Operation ) )
        {
            writeln( "Creating folder : ", folder_path );
        }

        try
        {
            folder_path.mkdirRecurse();
        }
        catch ( Exception exception )
        {
            Abort( "Can't create folder : " ~ folder_path, exception );
        }
    }
}

// ~~

void RemoveFolder(
    string folder_path
    )
{
    writeln( "Removing folder : ", folder_path );

    try
    {
        folder_path.rmdir();
    }
    catch ( Exception exception )
    {
        Abort( "Can't create folder : " ~ folder_path, exception );
    }
}

// ~~

void RemoveFile(
    string file_path
    )
{
    writeln( "Removing file : ", file_path );

    try
    {
        file_path.remove();
    }
    catch ( Exception exception )
    {
        Abort( "Can't remove file : " ~ file_path, exception );
    }
}

// ~~

void WriteByteArray(
    string file_path,
    ubyte[] file_byte_array,
    bool folder_is_created = true
    )
{
    if ( folder_is_created )
    {
        CreateFolder( file_path.dirName() );
    }

    if ( HasVerbosity( VERBOSITY.Operation ) )
    {
        writeln( "Writing file : ", file_path );
    }

    try
    {
        file_path.write( file_byte_array );
    }
    catch ( Exception exception )
    {
        Abort( "Can't write file : " ~ file_path, exception );
    }
}

// ~~

ubyte[] ReadByteArray(
    string file_path
    )
{
    ubyte[]
        file_byte_array;

    if ( HasVerbosity( VERBOSITY.Operation ) )
    {
        writeln( "Reading file : ", file_path );
    }

    try
    {
        file_byte_array = cast( ubyte[] )file_path.read();
    }
    catch ( Exception exception )
    {
        Abort( "Can't read file : " ~ file_path, exception );
    }

    return file_byte_array;
}

// ~~

void WriteText(
    string file_path,
    string file_text,
    bool folder_is_created = true
    )
{
    if ( folder_is_created )
    {
        CreateFolder( file_path.dirName() );
    }

    if ( HasVerbosity( VERBOSITY.Operation ) )
    {
        writeln( "Writing file : ", file_path );
    }

    file_text = file_text.stripRight();

    if ( file_text != ""
         && !file_text.endsWith( '\n' ) )
    {
        file_text ~= '\n';
    }

    try
    {
        if ( !file_path.exists()
             || file_path.readText() != file_text )
        {
            file_path.write( file_text );
        }
    }
    catch ( Exception exception )
    {
        Abort( "Can't write file : " ~ file_path, exception );
    }
}

// ~~

string ReadText(
    string file_path
    )
{
    string
        file_text;

    if ( HasVerbosity( VERBOSITY.Operation ) )
    {
        writeln( "Reading file : ", file_path );
    }

    try
    {
        file_text = file_path.readText();
    }
    catch ( Exception exception )
    {
        Abort( "Can't read file : " ~ file_path, exception );
    }

    return file_text;
}

