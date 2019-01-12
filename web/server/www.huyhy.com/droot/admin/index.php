<?php
$user = 'admin';
$pass = '1234567';

echo '<p>Have a secret message here ...</p>';

if (isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW']))
{
    if (($user != $_SERVER['PHP_AUTH_USER']) || ($pass != $_SERVER['PHP_AUTH_PW']))
    {
        header('WWW-Authenticate: Basic');
        header('HTTP/1.0 401 Unauthorized');
        echo '<p>Wrong user or password ...</p>';
        exit;
    } else {
        echo '<p>Secret message: This is a <a href="http://bit.ly/2D59yVq">map</a> to get treasure!!!</p>';
        exit;
    }
} else {
        header('WWW-Authenticate: Basic');
        header('HTTP/1.0 401 Unauthorized');
        echo '<p>Please sign in ...</p>';
        exit;
}
?>
