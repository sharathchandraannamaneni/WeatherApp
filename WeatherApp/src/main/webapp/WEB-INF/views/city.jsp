<%@page session="false"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Weather Application</title>
<style>
th {
	background-color: #00CCCC;
	color: white;
}
</style>
<c:url var="home" value="/" scope="request" />

<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css">
<script
	src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
</head>
<script src="<c:url value='/resources/javascript/main.js'/>"></script>

<div class="container text-center">
	<div class="page-header">
		<h3>
			<spring:message code="weather.heading" />
		</h3>
	</div>
</div>

<div class="container" style="min-height: 500px">

	<div class="starter-template">
		<br>

		<form class="form-horizontal" id="search-form">
			<div class="form-group form-group-lg">
				<label class="col-sm-2 control-label"><spring:message
						code="weather.city" /></label>
				<div class="col-sm-10">
					<input type=text id="city"
						title="Enter city name, use comma as separator to enter multiple cities"
						pattern="^[a-zA-Z, ]*$" class="form-control">
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<button type="submit" id="bth-search"
						class="btn btn-success btn-sm">
						<spring:message code="weather.search" />
					</button>
					<button type="reset" class="btn btn-primary btn-sm">
						<spring:message code="weather.reset" />
					</button>
				</div>
			</div>
		</form>

	</div>
	<div id="responseTable">
		<h1>
			<spring:message code="weather.response" />
		</h1>
		<div class="row col-md-12 table-responsive">
			<table id="weatherTable" class="table table-bordered table-hover">
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
	<div id="errorDiv">
		<div id="errorData" class="alert alert-danger"></div>
	</div>
</div>

<script>
	jQuery(document).ready(function($) {
		$("#errorDiv").hide();
		$("#errorData").html("");
		$("div#responseTable").hide();
		$("#search-form").submit(function(event) {
			enableSearch(false);
			event.preventDefault();
			getWeatherForCity();
		});

	});

	function getWeatherForCity() {
		var city = $("#city").val();
		city = city.trim();
		var valid = true;
		if (city.length == 0) {
			valid = false;
		}

		if ((city.length == 1 && ',' == city.charAt(0))) {
			valid = false;
		}
		if (!valid) {
			$("#errorData").html("Please enter a city to search");
			$("div#responseTable").hide();
			$("#errorDiv").show();
			return;
		}
		$
				.ajax({
					type : "GET",
					contentType : "application/json",
					url : "${home}search?city=" + city,
					dataType : 'json',
					timeout : 100000,
					success : function(data) {
						$("#weatherTable").empty();
						$("#weatherTable").append(
								"<tbody id='weather'></tbody>");
						var head = '<thead><tr><th>Name</th><th>Country</th><th>Description</th><th>Temperature</th><th>Pressure</th><th>Humidity</th><th>Min Temperature</th><th>Max Temperature</th></tr></thead>';
						$('#weatherTable').append(head);

						$.each(data, function(i, weather) {
							var row = '<tr>' + '<td>' + weather.name + '</td>'
									+ '<td>' + weather.country + '</td>'
									+ '<td>' + weather.description + '</td>'
									+ '<td>' + weather.temp + '</td>' + '<td>'
									+ weather.pressure + '</td>' + '<td>'
									+ weather.humidity + '</td>' + '<td>'
									+ weather.temp_min + '</td>' + '<td>'
									+ weather.temp_max + '</td>' + '</tr>';
							$('#weatherTable tbody').append(row);

						});

						$("#weatherTable tbody tr:odd").addClass("default");
						$("#weatherTable tbody tr:even").addClass("active");
						$("#errorData").html("");
						$("#errorDiv").hide();
						$("div#responseTable").show();
					},
					error : function(e) {
						console.log("ERROR: ", e);
						var json = e.responseJSON;
						var reason = json.reason;
						$("#errorData").html(reason);
						$("div#responseTable").hide();
						$("#errorDiv").show();
					},
					done : function(e) {
						console.log("DONE");
						enableSearch(true);
					}
				});

	}

	function enableSearch(flag) {
		$("#btn-search").prop("disabled", flag);
	}
</script>
</body>
</html>