<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.TicketChecker"%>
<%
TicketChecker checker=(TicketChecker)request.getAttribute("ticketChecker");
if(checker==null){
 response.sendRedirect(request.getContextPath()+"/ticket-checker/login.jsp");
 return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Scan Ticket | SNAPSPOT</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://unpkg.com/html5-qrcode"></script>
<style>
body{background:#f4f6f9}
#reader{width:100%;max-width:500px;margin:auto}
.card{border:none;border-radius:16px;box-shadow:0 8px 24px rgba(0,0,0,.08)}
</style>
</head>
<body>
<div class="container py-5">
<div class="card">
<div class="card-body">
<h3 class="text-center mb-4"><i class="bi bi-qr-code-scan"></i> Scan Parking Ticket</h3>

<div id="reader"></div>

<form id="scanForm" action="<%=request.getContextPath()%>/VerifyTicketServlet" method="post">
<input type="hidden" id="qrData" name="qrData">
</form>

<hr>

<h5>Manual Verification</h5>
<form action="<%=request.getContextPath()%>/VerifyTicketServlet" method="post">
<div class="input-group">
<input type="number" class="form-control" name="bookingId" placeholder="Enter Booking ID">
<button class="btn btn-success">Verify</button>
</div>
</form>

<div class="text-center mt-4">
<a href="<%=request.getContextPath()%>/TicketCheckerDashboardServlet" class="btn btn-secondary">
Back to Dashboard
</a>
</div>

</div>
</div>
</div>

<script>
function onScanSuccess(decodedText){
    html5QrCode.stop().then(function(){
        document.getElementById("qrData").value=decodedText;
        document.getElementById("scanForm").submit();
    });
}

const html5QrCode=new Html5Qrcode("reader");

Html5Qrcode.getCameras().then(function(cameras){
    if(cameras && cameras.length){
        html5QrCode.start(
            cameras[0].id,
            {fps:10, qrbox:250},
            onScanSuccess
        );
    }else{
        alert("No camera found.");
    }
}).catch(function(err){
    console.log(err);
    alert("Unable to access camera.");
});
</script>

</body>
</html>
