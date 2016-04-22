<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

try {
    $bdd = new PDO('mysql:host=localhost;dbname=BossInvader', 'guimeus', '');
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}

$check = "SELECT * FROM BossInvader.TablesSphere";
$res = $bdd->query($check);
$final = $res->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($final);

$bdd = null;