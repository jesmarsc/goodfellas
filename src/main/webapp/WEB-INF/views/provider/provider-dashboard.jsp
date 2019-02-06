<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Begin HTML Document -->
<!DOCTYPE html>
<html class="no-js" lang="en">

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Refresh" content="100"> <!-- used as a backup, will refresh entire page ever 100sec -->
    
    <!-- Title at the Tab of the Browser -->
	<title>Provider Dashboard</title>
   
    <link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/3.0.0/css/ionicons.css" rel="stylesheet">
	<link href="css/theme.css" rel="stylesheet">
	
        
</head>

<!-- Begin Body -->
<body>

	<div class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">

		<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
			<a class="navbar-brand" href="#">Kubernetes Konekt</a>
  
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarSupportedContent">
				<span class="navbar-toggler-icon"></span>
			</button>


			<div class="collapse navbar-collapse" id="navbarSupportedContent">
			
				
				<ul class="navbar-nav ml-auto">

					<li class="nav-item"><a class="nav-link"
					href="${pageContext.request.contextPath}/"> Home </a></li>
					
					<sec:authorize access="hasRole('USER')">
						<li class="nav-item"><a class="nav-link"
						href="${pageContext.request.contextPath}/user"> User Dashboard </a></li>
					</sec:authorize>
					<sec:authorize access="hasRole('PROVIDER')">
						<li class="nav-item"><a class="nav-link"
						href="${pageContext.request.contextPath}/provider"> Provider Dashboard </a></li>
					</sec:authorize>
					<li class="nav-item"><a class="nav-link" href="#">
							Messages </a></li>

					<li class="nav-item dropdown"><a
						class="nav-link dropdown-toggle" href="#" id="navDropdown"
						data-toggle="dropdown"> Alerts </a>
						<!-- later these alerts will be read from database for now there's a dummy drop down menu -->
						<div class="dropdown-menu">
							<a class="dropdown-item" href="#"> Frank Smith wants to buy
								Bad Cluster </a> <a class="dropdown-item" href="#"> Jesmar paid
								you $123.12 </a> <a class="dropdown-item" href="#"> Your account
								balance is $3456.02 </a>
						</div></li>

					<li class="nav-item"><a class="nav-link" href="#">Profile</a>
					</li>
				 
					<li class="nav-item">
						<a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
					</li>
				

				</ul>
			</div>
		</nav>
	</div>

	<!-- Begin Code for Forms -->
	<c:choose>
	    <c:when test="${not empty uploadClusterFailStatus}">
	    	<div class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">
	        <div class="alert alert-danger" role="alert">
			<strong>${uploadClusterFailStatus}</strong> ${uploadClusterFailMessage}
			</div>
			</div>
	    </c:when>
	    <c:when test="${not empty uploadClusterSuccessStatus}">
	    	<div class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">
	      	<div class="alert alert-success" role="alert">
			<strong>${uploadClusterSuccessStatus}</strong> ${uploadClusterSuccessMessage}
			</div>
			</div>
	    </c:when>
	        <c:when test="${not empty deleteClusterSuccessStatus}">
	    	<div class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">
	      	<div class="alert alert-danger" role="alert">
			<strong>${deleteClusterSuccessStatus}</strong> ${deleteClusterSuccessMessage}
			</div>
			</div>
	    </c:when>
		<c:when test="${not empty deleteContainerToClusterStatus}">
			<div class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">
				<div class="alert alert-danger" role="alert">
					<strong>${deleteContainerToClusterStatus}</strong>
					${deleteContainerToClusterMessage}
				</div>
			</div>
		</c:when>
		<c:otherwise>
	
	    </c:otherwise>
	</c:choose>
	
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
	<script>
		/* function autoRefresh() {
			   $('#cluster-div').load('sample.jsp' ); }
		autoRefresh();
		setInterval(autoRefresh(), 10); */

		      /*  $('#lmao').html("<h3>My Clusters</h3><table class='table table-bordered'><thead class='thead-light'><tr><th><h5>Cluster URL</h5></th><th><h5>Options</h5></th></tr></thead><tbody><c:forEach var='cluster' items='${currentAccount.clusters}'><c:url var='removeLink' value='/provider/delete'><c:param name='clusterUrl' value='${cluster.clusterUrl}' /></c:url><tr><td>${cluster.clusterUrl}</td><td><a class='btn btn-outline-primary' href='${removeLink}' onclick='if(!(confirm('Are you sure you want to delete cluster')))return false' role='button'>Delete Cluster</a><a class='btn btn-light' href='#' role='button'>Another Option</a></td></tr></c:forEach></tbody></table><h3>Running On Your Clusters</h3><table class='table table-bordered table-striped'><thead><tr><th>Cluster URL</th><th>Name</th><th>Kind</th><th>Option(s)</th></tr></thead><tbody><c:forEach var='container' items='${runningContainers}'><c:url var='removeLink' value='/provider/delete-container'><c:param name='containerId' value='${container.id}' /></c:url><tr><td>${container.clusterUrl}</td><td>${container.containerName}</td>	<td>${container.kind}</td><td><a class='btn btn-primary' href='${removeLink}' onclick='if(!(confirm('Are you sure you want to delete container')))return false' role='button'>Delete Container</a></td></tr></c:forEach></tbody></table><br/><div class-'mx-4 my-4'><h3>Upload New Cluster URL</h3></div><form:form action='/provider/upload' modelAttribute='newClusterForm'><div class='form-group row mx-1 my-4 col-sm-10 col-md-10 col-lg-6'><label> Cluster URL (i.e. 'https://122.198.122.166'): </label><form:input class='form-control' path='clusterUrl' /><form:errors path='clusterUrl' cssClass='error' /></div><div class='form-group row mx-1 my-4 col-sm-10 col-md-10 col-lg-6'><label> Cluster Username (must have admin privileges): </label><form:input class='form-control' path='clusterUsername' /><form:errors path='clusterUsername' cssClass='error' /></div><div class='form-group row mx-1 my-4 col-sm-10 col-md-10 col-lg-6'><label> Cluster Password: </label><form:password class='form-control' path='clusterPassword' /><form:errors path='clusterPassword' cssClass='error' /></div><div class='form-group row mx-4 my-4'><input class='btn btn-primary text-center' type='submit' value='Submit' /></div><br/><br/></form:form> " ); 
		       }, 1000); */
		       
		  		/* $(document).ready(function() {
					setInterval(function() {
						$('#cluster-div').load('sample.jsp' );
	            	},1000);
	            }); */
	            function sendRequest(){
	                $.ajax(
	                    url: "sample.jsp",
	                    cache: false,
	                    success: 
	                    	function(result){
	                        	$('#cluster-div').load(result); 	          
	                    },
	                	error: 
	                		function(result) {
	                        alert('something bad happened');
	                 	},
	                 	complete: 
	               			function(){
	                 		setTimeout(sendRequest,1000);
	                 	}
	                });
	            }
	</script>
	
	
	<div id="cluster-div" class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">
	<%@ include file="sample.jsp" %>
	</div>
	<div id="sample" class="container mx-1"> ... </div>
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
	<script src="js/scripts.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>	

</body>

</html>
