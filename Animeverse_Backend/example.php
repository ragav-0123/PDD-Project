<?php
include('db.php');
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate required fields
    if (
        isset($_POST['name']) && 
        isset($_POST['email']) && 
        isset($_POST['age']) && 
        isset($_POST['password'])
    ) {
        $name = $_POST['name'];
        $email = $_POST['email'];
        $age = $_POST['age'];
        $password = $_POST['password'];

        // Insert data into the database
        $sql = "INSERT INTO register (name, email, age, password) VALUES ('$name', '$email', '$age', '$password')";
        if ($conn->query($sql)) {
            // Fetch the newly inserted record
            $last_id = $conn->insert_id;
            $result = $conn->query("SELECT user_id, name, email FROM register WHERE user_id = $last_id");

            if ($result && $row = $result->fetch_assoc()) {
                echo json_encode([
                    "Status" => "True",
                    "Message" => "Record added successfully.",
                    "Data" => $row
                ]);
            } else {
                echo json_encode([
                    "Status" => "False",
                    "Message" => "Error fetching inserted data.",
                    "Data" => []
                ]);
            }
        } else {
            echo json_encode([
                "Status" => "False",
                "Message" => "Error: " . $conn->error,
                "Data" => []
            ]);
        }
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "Invalid input or missing required fields.",
            "Data" => []
        ]);
    }
} else {
    echo json_encode([
        "Status" => "False",
        "Message" => "Invalid request method.",
        "Data" => []
    ]);
}
?>
