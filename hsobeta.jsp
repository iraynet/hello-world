<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ page import="java.io.*, java.util.*, self.fin.tools.*, self.fin.objects.*, org.json.*, java.text.SimpleDateFormat, java.net.URL, java.text.DecimalFormat, java.lang.reflect.Field" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-108374515-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-108374515-1');
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LOVE LETTER (beta)</title>
<style>
    table {
    	border-collapse: collapse;    	
    }
	table, th, td {
		padding: 5px;
		border: 1px solid grey;	
		font-size: 12px;
		font-family: Arial;		
	}
	tr:nth-child(even) {
		background: #eee;
	}
	tr:nth-child(odd) {
		background: #fff;
	}
	td:nth-child(n+2) {
		text-align: right;
	}
	body {
		font-size: 12px;
		font-family: Arial;	
		color: #333333;		
	}
	.call {
		color: green;
	}
	.put {
		color: red;
	}
	.b {
		font-weight:bold;
		color: #000000;	
	}
	.form td {
		text-align: left;
	}
	.text-left {
		text-align: left;
	}
	
	.over50 { background: #ebfaeb; }
.over60 { background: #c2f0c2; }
.over70 { background: #99e699; }
.over80 { background: #70db70; }
.over90 { background: #47d147; }

.under50 { background: #ffe6e6; }
.under60 { background: #ffb3b3; }
.under70 { background: #ff8080; }
.under80 { background: #ff4d4d; }
.under90 { background: #ff1a1a; }
	
	.main {
		margin: 0 auto;
		width: 80%;	
	}
	.selected {
		background-color:#FFFF00;
	}
	</style>
</head>
<body>
<%
String line = null;
try 
{
//Check window or linux
if (System.getProperty("os.name").toLowerCase().indexOf("win") >= 0) 
{
	path = "C:/Users/rchan/Documents/Personal/";	
}

//Check timezone - can have better config
Calendar now = Calendar.getInstance();
Calendar dateOfWork = Calendar.getInstance();

if (now.getTimeZone().getID().equals("UTC")) {
	now.add(Calendar.HOUR, 8);	
}
System.out.println(now.getTime());

Calendar startDate = Calendar.getInstance();
/* if (request.getParameter("d")!=null && request.getParameter("d").matches("[0-9]{6}")) {
	startDate.setTime(sdfHtml.parse(request.getParameter("d")));
} else {
	startDate.setTimeInMillis(now.getTimeInMillis());
} */
SearchForm sf = new SearchForm();
sf.turnoverFrom = 200;
sf.date = dateOfWork.getTime();
//Retrieve historical file with filters
if (request.getParameter("d")!=null && request.getParameter("d").matches("[0-9]{4}-[0-9]{2}-[0-9]{2}")) 
{
	try {
		sf.date = sdfRead.parse(request.getParameter("d"));
		sf.turnoverFrom = Long.parseLong(request.getParameter("coi"));
		sf.showClose = request.getParameter("showclose");
	} catch (Exception e) {
		
	}
}
%>
<form method="POST" action="<%=request.getRequestURI().replace(".jsp","")%>" name="frmFilter">
<table class="form">
<tr><td>Date</td><td colspan="2"><input type="date" value="<%=sf.date==null?"":sdfRead.format(sf.date) %>" name="d" id="d"/><% //=sbOptionDate.toString() %></td><td rowspan="3">例︰<img src="howtoread-v1.png" /></td></tr>
<tr><td>Display Change OI &gt;=</td><td><input type="number" min="0" max="10000" name="coi" id="coi" value="<%=printSearchValue(sf.turnoverFrom) %>" /> 深色數字</td>
<td>Display O.Q.P. CLOSE <input type="checkbox" name="showclose" id="showclose" value="y" <%=sf.showClose!=null&&sf.showClose.equals("y")?"checked":""%> /></td></tr>
</table>
<input type="submit" value="Apply" />
<input type="button" value="Reset" onclick="frmReset();"/>
<input type="button" value="Clear" onclick="frmClear();"/>
</form>
<p>濃度&gt;=0.5有顏色，<font style="color:green;">綠色+ve</font>，<font style="color:red;">紅色-ve</font>，濃度xChange OI越高越深色。每晚10點半更新。</p>
<script>
	function frmReset() {
		document.getElementById("d").value = "<%=sdfRead.format(dateOfWork.getTime()) %>";
		document.getElementById("coi").value ="200";
		document.getElementById("showclose").checked = false;		
	}
	function frmClear() {
		document.getElementById("d").value = "";
		document.getElementById("coi").value ="0";	
		document.getElementById("showclose").checked = false;	
	}
</script>
<%
startDate.setTimeInMillis(sf.date.getTime());

dateOfWork.setTimeInMillis(startDate.getTimeInMillis());

String currentMonth = sdfParam.format(dateOfWork.getTime()).toUpperCase();
dateOfWork.set(Calendar.DATE, 1); //Add 1 to get next month
dateOfWork.add(Calendar.MONTH, 1); //Add 1 to get next month
String nextMonth = sdfParam.format(dateOfWork.getTime()).toUpperCase();
dateOfWork.set(Calendar.DATE, 1); //Add 1 to get next month
dateOfWork.add(Calendar.MONTH, 2); //Add 1 to get next month
String nextQuarter = sdfParam.format(dateOfWork.getTime()).toUpperCase();
dateOfWork.set(Calendar.DATE, 1); //Add 1 to get next month
dateOfWork.add(Calendar.MONTH, 3); //Add 1 to get next month
String nextHalfYear = sdfParam.format(dateOfWork.getTime()).toUpperCase();
dateOfWork.set(Calendar.DATE, 1); //Add 1 to get next month
dateOfWork.add(Calendar.MONTH, 6); //Add 1 to get next month
String nextYear = sdfParam.format(dateOfWork.getTime()).toUpperCase();


Calendar lastTradeDayOfTheMonth = Calendar.getInstance();
dateOfWork.setTimeInMillis(startDate.getTimeInMillis());
//check previous month if the report is viewing current month
if (dateOfWork.get(Calendar.MONTH) == now.get(Calendar.MONTH)) {
	dateOfWork.add(Calendar.MONTH, -1);
}
dateOfWork.set(Calendar.DATE, dateOfWork.getActualMaximum(Calendar.DATE));
File fileHkexHso = new File(path + subPath + sdfFolder.format(dateOfWork.getTime()) + "hkexhso-"+ sdfFile.format(dateOfWork.getTime())+".htm");
while (!fileHkexHso.exists()) {
	dateOfWork.add(Calendar.DATE, -1);
	fileHkexHso = new File(path + subPath + sdfFolder.format(dateOfWork.getTime()) + "hkexhso-"+ sdfFile.format(dateOfWork.getTime())+".htm");
	
}
if (dateOfWork.after(startDate)) 
{
	dateOfWork.add(Calendar.MONTH, -1);
	dateOfWork.set(Calendar.DATE, dateOfWork.getActualMaximum(Calendar.DATE));
	fileHkexHso = new File(path + subPath + sdfFolder.format(dateOfWork.getTime()) + "hkexhso-"+ sdfFile.format(dateOfWork.getTime())+".htm");
	while (!fileHkexHso.exists()) {
		dateOfWork.add(Calendar.DATE, -1);
		fileHkexHso = new File(path + subPath + sdfFolder.format(dateOfWork.getTime()) + "hkexhso-"+ sdfFile.format(dateOfWork.getTime())+".htm");
	}
}
lastTradeDayOfTheMonth.setTimeInMillis(dateOfWork.getTimeInMillis());

//START
dateOfWork.setTimeInMillis(startDate.getTimeInMillis());

//Start Get Filter Form
boolean isLocalData = true;
File localFile = null;

String maxOICurrentCall = "";
String maxOICurrentPut = "";
String maxOINextCall = "";
String maxOINextPut = "";

int dayCounter = 0;

String [] header = {"CONTR","STRIKE","O.Q.P", "VOL", "CHG IO", "CONCENT"};
//String [] header = {"CONTRACT","STRIKE","OPENING","HIGH","LOW","O.Q.P.CLOSE", "O.Q.P.CHANGE", "IV%", "VOL", "OPEN INT.", "CHG IO", "CONCENT"};

HashMap<String, HashMap<String, Hso>> dailyHso = new HashMap<String, HashMap<String, Hso>>();
ArrayList<String> xAxis = new ArrayList<String>();
ArrayList<String> yAxis = new ArrayList<String>();
HashMap<String, HashMap<String, Hso>> allBigOpens = new HashMap<String, HashMap<String, Hso>>();

while (dateOfWork.after(lastTradeDayOfTheMonth) || dateOfWork.equals(lastTradeDayOfTheMonth) /*Get pervious month end*/) 
{
HashMap<String, Hso> bigOpen = null;

	fileHkexHso = new File(path + subPath + sdfFolder.format(dateOfWork.getTime()) + "hkexhso-"+ sdfFile.format(dateOfWork.getTime())+".htm");
	if (fileHkexHso.exists()) 
	{	
		HashMap<String, Hso> data = new HashMap<String, Hso>();
		
		InputStreamReader fileIn = new InputStreamReader(new FileInputStream(fileHkexHso), "UTF-8");
		BufferedReader br = new BufferedReader(fileIn);
		
		int counterLine = 0;
		int startOfData = 36;
		String endOfData = "END OF REPORT";
		
		while ((line = br.readLine()) != null) 
		{
			line = this.cleanLine(line);
			counterLine++;
			
			if (line.indexOf(endOfData) >= 0) 
			{	
				break;
			}
			
			if (counterLine >= startOfData && line.length() == 90) 
			{
				//0         1         2         3         4         5         6         7         8         9  
				//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				//MAR-18  16800 C       0       0       0   14653     -133    0        0         8         0
				int [] pos = {0, 7, 16, 24, 32, 40, 48, 57, 62, 71, 81, 90};
				String [] values = {"", "", "", "", "",  "", "", "", "", "", "", ""};
				for (int i=0; i<pos.length-1; i++) {
					values[i] = line.substring(pos[i], pos[i+1]).trim();
					if (values[i].equals("-")) {
						values[i] = strNA;
					}
				}
				if (values[0].matches("[A-Z]{3}-[0-9]{2}")) 
				{
					Hso hso = new Hso();
					hso.contractMonth = values[0];
					hso.strikePrice = values[1];
					hso.openingPrice = Integer.parseInt(values[2]);
					hso.dayHigh = Integer.parseInt(values[3]);
					hso.dayLow = Integer.parseInt(values[4]);
					hso.close = Integer.parseInt(values[5]);
					hso.change = Integer.parseInt(values[6]);
					hso.ivPercentage = Integer.parseInt(values[7]);
					hso.volume = Integer.parseInt(values[8]);
					hso.openInterest = Integer.parseInt(values[9]);
					hso.changeInOI = Integer.parseInt(values[10]);
					
					if (hso.contractMonth.equals(currentMonth) || hso.contractMonth.equals(nextMonth)) 
					{
char side = hso.strikePrice.trim().charAt(hso.strikePrice.length()-1);
if (allBigOpens.containsKey(sdfFile.format(dateOfWork.getTime())+hso.contractMonth+side)) 
{
	bigOpen = allBigOpens.get(sdfFile.format(dateOfWork.getTime())+hso.contractMonth+side);
}
else 
{
	bigOpen = new HashMap<String, Hso>();
}
boolean isDone = false;
if (bigOpen.containsKey("1")) {
 Hso big1 = bigOpen.get("1");
 if (hso.openInterest > big1.openInterest) {
  bigOpen.put("3", bigOpen.get("2"));
  bigOpen.put("2", bigOpen.get("1"));
  bigOpen.put("1", hso);
  isDone = true;
 } 
}
else {
 bigOpen.put("1", hso);
 isDone = true;
}

if (!isDone) {
if (bigOpen.containsKey("2")) {
 Hso big2 = bigOpen.get("2");
 if (hso.openInterest > big2.openInterest) {
  bigOpen.put("3", bigOpen.get("2"));
  bigOpen.put("2", hso);
  isDone = true;  
 }
} else {
 bigOpen.put("2", hso);
 isDone = true;
}
}
if (!isDone) {
if (bigOpen.containsKey("3")) {
 Hso big3 = bigOpen.get("3");
 if (hso.openInterest > big3.openInterest) {
  bigOpen.put("3", hso);
  isDone = true;  
 }
} else {
 bigOpen.put("3", hso);
 isDone = true;
}
}
allBigOpens.put(sdfFile.format(dateOfWork.getTime())+hso.contractMonth+side, bigOpen);



					}
					/*	if (hso.strikePrice.endsWith("C")) {
							maxOICurrentCall = hso.openInterest;	
						} else if (hso.strikePrice.endsWith("P")) {
							maxOICurrentPut = hso.openInterest;
						}
						
					} 
					else if (hso.contractMonth.equals(nextMonth)) 
					{
						if (hso.strikePrice.endsWith("C")) {
							maxOINextCall = hso.openInterest;	
						} else if (hso.strikePrice.endsWith("P")) {
							maxOINextPut = hso.openInterest;
						}	
					} */
					
					if (hso.volume == 0 || hso.changeInOI == intNA || hso.volume == intNA) {
						hso.concentration = intNA;
					} else {
						hso.concentration = Math.abs(hso.changeInOI)/1.0/hso.volume;
					}
					
					if (!xAxis.contains(hso.contractMonth+SEPARATOR+hso.strikePrice)) {// && (hso.contractMonth.equals(currentMonth) || hso.contractMonth.equals(nextMonth))) {
						xAxis.add(hso.contractMonth+SEPARATOR+hso.strikePrice);						
					}
					data.put(hso.contractMonth+SEPARATOR+hso.strikePrice, hso);
				}
			}
		}
		br.close();
		fileIn.close();
		
		dailyHso.put(sdfFile.format(dateOfWork.getTime()), data);
		yAxis.add(sdfFile.format(dateOfWork.getTime()));
	
		if (dayCounter>32) {
			break;
		}
		dayCounter++;	
	}
	dateOfWork.add(Calendar.DATE, -1);
}

/* dateOfWork.setTimeInMillis(sf.date.getTime());
dateOfWork.add(Calendar.DATE, -1); */

out.println("<table>");
/* out.println("<tr>");
out.println("<th>CONTR/STRIKE</th>");
for (int y=0; y<yAxis.size(); y++) 
{
	out.println("<th>"+yAxis.get(y)+"</th>");
}
out.println("</tr>"); */

String currentContr = "";

for (int x=0; x<xAxis.size(); x++) 
{
	boolean show = false;
	StringBuffer row = new StringBuffer();
	
	String key = xAxis.get(x);
	String [] temp = key.split(SEPARATOR);
	String tempContr = temp[0];
	char side = temp[1].trim().charAt(temp[1].length()-1);
	if (side == 'C') {
		tempContr += " CALL";
	} else if (side == 'P') {
		tempContr += " PUT";
	}	

	if (!currentContr.equals(tempContr)) 
	{
		if (!currentContr.equals("")) {
			out.println("</tr><tr><td colspan='"+(yAxis.size()+1)+"'></td></tr>");
		}
		//out.println("<table>");
		out.println("<tr>");
		out.println("<th>"+tempContr+"</th>");
		for (int y=0; y<yAxis.size(); y++) 
		{
			out.println("<th>"+yAxis.get(y)+"</th>");

		}
if (temp[0].equals(currentMonth) || temp[0].equals(nextMonth)) {		
		out.println("<tr class='text-left'>");
		out.println("<th>最大未平倉</th>");
		for (int y=0; y<yAxis.size(); y++) 
		{
			out.println("<th>");
HashMap<String, Hso> bigOpen = allBigOpens.get(yAxis.get(y)+temp[0] + side);
out.println(bigOpen.get("1").strikePrice);
out.println("<br />"+bigOpen.get("2").strikePrice);
out.println("<br />"+bigOpen.get("3").strikePrice);
out.println("</th>");
		}
		out.println("</tr>");
}

		currentContr = tempContr;
	}
	
	for (int y=0; y<yAxis.size(); y++) 
	{	
		String dayKey = yAxis.get(y);
		HashMap<String, Hso> data = dailyHso.get(dayKey);
		
		Hso hso = data.get(key);	
		if (hso == null) 
		{
			row.append("<td>N/A</td>");
		} 
		else 
		{
			if (y==0) {
				row.append("<td>"+hso.contractMonth+"<br />"+hso.strikePrice+"</td>");
			}
			String css = "";
			String bold = "";
			String sign = "";
			if (hso.changeInOI != intNA && Math.abs(hso.changeInOI) > sf.turnoverFrom) {
				show = true;
				if (Math.abs(hso.changeInOI) > sf.turnoverFrom) {
					bold = " b";
					css = "class='"+bold+"'";
				}
				if (hso.changeInOI > 0) {
					sign = "over";
				} else {
					sign = "under";
				}
				
				/* if (hso.concentration >= 0.9) {
					css = "class='"+sign+"90 "+bold+"'";
				} else if (hso.concentration >= 0.8) {
					css = "class='"+sign+"80 "+bold+"'";
				} else if (hso.concentration >= 0.7) {
					css = "class='"+sign+"70 "+bold+"'";
				} else if (hso.concentration >= 0.6) {
					css = "class='"+sign+"60 "+bold+"'";
				} else if (hso.concentration >= 0.5) {
					css = "class='"+sign+"50 "+bold+"'";
				} */
				if (hso.concentration >= 0.5) {
					if (hso.concentration * Math.abs(hso.changeInOI) >= 500) {
						css = "class='"+sign+"90 "+bold+"'";
					} else if (hso.concentration * Math.abs(hso.changeInOI) >= 400) {
						css = "class='"+sign+"80 "+bold+"'";
					} else if (hso.concentration * Math.abs(hso.changeInOI) >= 300) {
						css = "class='"+sign+"70 "+bold+"'";
					} else if (hso.concentration * Math.abs(hso.changeInOI) >= 200) {
						css = "class='"+sign+"60 "+bold+"'";
					} else if (hso.concentration * Math.abs(hso.changeInOI) >= 100) {
						css = "class='"+sign+"50 "+bold+"'";
					}
				}
			}
			row.append("<td "+css+">"+printNumericValue(hso.changeInOI) + "<br /> " + printNumericValue3dp(hso.concentration));
			if (sf.showClose!=null && sf.showClose.equals("y")) {
				row.append("<br /> " + printNumericValue(hso.close));
			}
			/*if (sf.showOpenInterest!=null && sf.showOpenInterest.equals("y")) {
				row.append("<br /> " + printNumericValue(hso.openInterest));
			}*/
			row.append("</td>");
				
		}
	}
	if (show) {
		out.println("<tr>" + row.toString() + "</tr>");	
	}
}
out.println("</table>");

} 
catch (Exception e) 
{
	System.out.println(line);
	e.printStackTrace(System.out);
}
%>
</body>
</html>
<%!
private String path = "/home/mr_chan_ray/data/";
private String subPath = "hso/";
private String strNA = "-99999";
private int intNA = -99999;
private String SEPARATOR = "!";

//Formatting
private SimpleDateFormat sdfFolder = new SimpleDateFormat("yyyy/MM/");
private SimpleDateFormat sdfFile = new SimpleDateFormat("yyyyMMdd");
private SimpleDateFormat sdfHtml = new SimpleDateFormat("yyMMdd");
private SimpleDateFormat sdfLog = new SimpleDateFormat("yyyyMMddHHmmss");
private SimpleDateFormat sdfRead = new SimpleDateFormat("yyyy-MM-dd");
private SimpleDateFormat sdfData = new SimpleDateFormat("yyyy/MM/dd HH:mm");
private SimpleDateFormat sdfParam = new SimpleDateFormat("MMM-yy");

private String cleanLine(String line) {
	return line.replace("&nbsp;", " ").replace("&amp;", "&").replace("'", "\"").replace("</font></pre><pre><font size=\"1\">", "");
}

private String cleanNumericValue(String value) {
	value = value.replace(",","").trim();
	if (value.endsWith("T")) {
		java.math.BigDecimal bd = new java.math.BigDecimal(value.substring(0, value.length()-1));
		bd = bd.multiply(new java.math.BigDecimal("1000000000000"));
	 	value = String.valueOf(bd.longValue());
	}
	if (value.endsWith("B")) {
		java.math.BigDecimal bd = new java.math.BigDecimal(value.substring(0, value.length()-1));
		bd = bd.multiply(new java.math.BigDecimal("1000000000"));
	 	value = String.valueOf(bd.longValue());
	}
	if (value.endsWith("M")) {
		java.math.BigDecimal bd = new java.math.BigDecimal(value.substring(0, value.length()-1));
		bd = bd.multiply(new java.math.BigDecimal("1000000"));
	 	value = String.valueOf(bd.longValue());
	}
	if (value.endsWith("%")) {
		java.math.BigDecimal bd = new java.math.BigDecimal(value.substring(0, value.length()-1));
		bd = bd.divide(new java.math.BigDecimal("100"));
	 	value = String.valueOf(bd.doubleValue());
	}
	if (value == null || value.equals("N/A") || value.equals("無") || value.equals("∞") || value.equals("undefined") || value.equals("前收市價") || value.equals("")) {
		value = strNA;
	}
	else if (value.equals("A")) { //Market Cap is A, not sure the meaning
		value = "0";
	}
	return value;
}
private String printNumericValue(int value) {
	if (value == intNA) {
		return "N/A";
	} else {
		return String.valueOf(value); 		
	}
}
private String printNumericValue(long value) {
	if (value == intNA) {
		return "N/A";
	} else {
		DecimalFormat dfLong = new DecimalFormat("#,##0");
		return dfLong.format(value).replace(",000,000,000", "B").replace(",000,000", "M").replace(",000", "K"); 		
	}
}
private String printPercentageValue(double value) {
	if (value == intNA) {
		return "N/A";
	} else {
		DecimalFormat dfLong = new DecimalFormat("#,##0.00%");
		return dfLong.format(value);
		//return dfLong.format(value*100)+"%"; 		
	}
}
private String printNumericValue(double value) {
	if (value == intNA) {
		return "N/A";
	} else {
		DecimalFormat dfDecimal = new DecimalFormat("#,##0.00");
		return dfDecimal.format(value); 		
	}
}
private String printNumericValue3dp(double value) {
	if (value == intNA) {
		return "N/A";
	} else {
		DecimalFormat dfDecimal = new DecimalFormat("#,##0.000");
		return dfDecimal.format(value); 		
	}
}

private String printSearchValue(double value) {
	if (value == SearchForm.EMPTY_NUMERIC) {
		return "";
	} else {
		DecimalFormat dfLong = new DecimalFormat("0");
		return dfLong.format(value); 		
	}
}
private String printSearchValue2dp(double value) {
	if (value == SearchForm.EMPTY_NUMERIC) {
		return "";
	} else {
		DecimalFormat dfLong = new DecimalFormat("0.00");
		return dfLong.format(value); 		
	}
}
private String printSearchPercentageValue(double value) {
	if (value == SearchForm.EMPTY_NUMERIC) {
		return "";
	} else {
		DecimalFormat dfLong = new DecimalFormat("0.00");
		return dfLong.format(value*100); 		
	}
}

%>

