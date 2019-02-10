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
    
    <!-- Title at the Tab of the Browser -->
	<title>Provider Dashboard</title>
    
    <meta name="description" content="Tequila is a free, open source Bootstrap 4 theme" />
    <meta name="generator" content="Themestr.app">
    <link rel="icon" href="http://themes.guide/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="http://themes.guide/favicon.ico" type="image/x-icon" />
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/3.0.0/css/ionicons.css" rel="stylesheet">
	<link href="css/theme.css" rel="stylesheet">
	<link type="text/css" rel="stylesheet" href="<c:url value="css/theme.css" />" />

</head>

<!-- Begin Body -->

<body>
<div class="view " style="background-image: url('images/background_image_goodfellas.png'); background-repeat: no-repeat; background-size: cover; background-position: initial;">

	<div class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">

		<nav class="navbar navbar-expand-lg navbar-dark transparent">
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
i	<c:choose>
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

	<div class="container  mx-1 my-4 col-sm-10 col-md-10 col-lg-12">

		<h3>My Clusters</h3>
		<!-- Beginning of table -->
		<table class="table table-hover table-bordered table-striped	">
			<thead class="thead-transparent" >
				<tr>
					<th><h4>Cluster URL</h4></th>
					<th><h4>Options</h4></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="cluster" items="${currentAccount.clusters}">
					<c:url var="removeLink" value="/provider/delete">
						<c:param name="clusterUrl" value="${cluster.clusterUrl}" />
					</c:url>
					
					<tr>
						<td><h6 >${cluster.clusterUrl}</h6></td>
						<td>
							<a class="btn btn-outline-light" href="${removeLink}" onclick="if(!(confirm('Are you sure you want to delete cluster')))return false" role="button">Delete Cluster</a>
							<a class="btn btn-light" href="#" role="button">Another Option</a>
							<a class="btn btn-outline-light" data-toggle="collapse" role="button" aria-expanded="false" aria-controls="multiCollapseExample1"href="#multiCollapseExample1" role="button">Metrics</a>
							  <div class="col">
    							<div class="collapse multi-collapse" id="multiCollapseExample1">
    							  <div class="card card-body">
     							   Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident.
      								</div>
  								  </div>
 								 </div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<!-- End of Table -->

		<h3>Running On Your Clusters</h3>
		<!-- Beginning of table -->
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th><h4 >Cluster URL</h4></th>
					<th><h4 >Name</h4></th>
					<th><h4 >Kind</h4></th>
					<th><h4 >Option(s)</h4></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="container" items="${runningContainers}">
					<c:url var="removeLink" value="/provider/delete-container">
						<c:param name="containerId" value="${container.id}" />
					</c:url>
					<tr>
						<td><h6 >${container.clusterUrl}</h6></td>
						<td><h6 >${container.containerName}</h6></td>
						<td><h6 >${container.kind}</h6></td>
						<td>
							<a class="btn btn-light" href="${removeLink}" onclick="if(!(confirm('Are you sure you want to delete container')))return false" role="button">Delete Container</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<!-- End of Table -->
		<br/>
		<div class-"mx-4 my-4">
			<h3>Upload New Cluster URL</h3>
		</div>
		
		<!-- New cluster upload -->
		<form:form action="/provider/upload" modelAttribute="newClusterForm">
			<!-- Action will be to send to confirmation page and validate -->
			<div class="form-group row mx-1 my-4 col-sm-10 col-md-10 col-lg-6">
				<label><font face="Voltaire" color="#fff"> Cluster URL (i.e. https://122.198.122.166):</font></label>
				<form:input class="form-control" path="clusterUrl" />
				<form:errors path="clusterUrl" cssClass="error" />
			</div>
			<div class="form-group row mx-1 my-4 col-sm-10 col-md-10 col-lg-6">
				<label> <font face="Voltaire" color="#fff"> Cluster Username (must have admin privileges):</font> </label>
				<form:input class="form-control" path="clusterUsername" />
				<form:errors path="clusterUsername" cssClass="error" />
			</div>
			<div class="form-group row mx-1 my-4 col-sm-10 col-md-10 col-lg-6">
				<label><font face="Voltaire" color="#fff">  Cluster Password: </font></label>
				<form:password class="form-control" path="clusterPassword" />
				<form:errors path="clusterPassword" cssClass="error" />
			</div>
			<div class="form-group row mx-4 my-4">
				<input class="btn btn-light text-center" type="submit"
					value="Submit" />
			</div>
			
			<br/><br/>
		</form:form>
	</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
	<script src="js/scripts.js"></script>
</body>
</html>
