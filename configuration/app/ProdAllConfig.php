<?php
declare(strict_types=1);

/** THE framework production config
 *
 * @author Lionel Péramo
 */

namespace otra\config;

use const otra\cache\php\BASE_PATH;
use const otra\cache\php\BUNDLES_PATH;
use const otra\cache\php\CACHE_PATH;

const CACHE_TIME = 300; // 5 minutes(5*60)

/**
 * @package config
 */
abstract class AllConfig
{
  public static int $verbose = 0;
  public static bool $cssSourceMaps = true;
  public static string
    /* To not make new AllConfig::$foo before calling CACHE_PATH, use directly AllConfig::$cachePath in this case
    (if we not use AllConfig::$foo it will not load AllConfig even if it's in the use statement so the "defines" aren't
    accessible) */
    $cachePath = CACHE_PATH,
    $defaultConn = '',  // mandatory to modify it later if needed
    $nodeBinariesPath = '/usr/local/bin/',  // mandatory to modify it later if needed
    $sassBinary = '/usr/local/bin/sass/', // mandatory to modify it later if needed
    $typeScriptBinary = '/usr/local/bin/tsc/'; // mandatory to modify it later if needed
  public static array
    $dbConnections = [], // mandatory to modify it later if needed
    $debugConfig = [], // mandatory to modify it later if needed
    $sassLoadPaths = [];
}
