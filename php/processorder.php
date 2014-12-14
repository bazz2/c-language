<html>
<head>
	<title>My title</title>
</head>
<body>
	<h1>My auto Parts-order Results</h1>
	<h2>Order Result</h2>
	<?php
		echo "<p>Order processed at ".date('H:i, jS F Y')."</p>";
		echo "<p>tire: ".$_POST['tireqty']."</p>";
		echo "<p>oil: ".$_POST['oilqty']."</p>";
	?>
</body>
</html>
