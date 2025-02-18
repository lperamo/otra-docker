<?php
declare(strict_types=1);

/** THE framework development config
 *
 * @author Lionel Péramo */
namespace otra\config;

use const otra\cache\php\BUNDLES_PATH;
use const otra\cache\php\CACHE_PATH;
use const otra\cache\php\COMPILE_MODE_MODIFY;

define('otra\\cache\\php\\CACHE_TIME', 300); // 5 minutes(5*60)
define('otra\\cache\\php\\COMPILE_MODE_MODIFY', 0);
define('otra\\cache\\php\\COMPILE_MODE_SAVE', 1);

/**
 * @package config
 */
abstract class AllConfig
{
  public static int
    $verbose = 1;
  public static bool
    $debug = true,
    $cache = false;
  public static string
    /* To not make new AllConfig::foo before calling CACHE_PATH, use directly AllConfig::$cachePath in this case
    (if we not use AllConfig::foo it will not load AllConfig even if it's in the use statement so the "defines" aren't
    accessible) */
    $cachePath = CACHE_PATH,
    $defaultConn = '', // mandatory to modify it later if needed
    $nodeBinariesPath = '/usr/local/bin/';  // mandatory to modify it later if needed
  public static array
    $dbConnections = [],// mandatory to modify it later if needed
    $debugConfig = [
    'autoLaunch' => true,
    'barPosition' => 'bottom',
    'maxChildren' => 128,
    'maxData' => 512,
    'maxDepth' => 3
  ],
    $taskFolders = [], // mandatory to modify it later if needed
    $sassLoadPaths = [];
}
