class Tcases
{
  var cases;
  var deaths;
  var recovered;
  var updated;
  var active;
  var critical;
  var todayCases;
  var todayDeaths;
  var todayRecovered;
  var casesPerOneMillion;
  var deathsPerOneMillion;
  var activePerOneMillion;
  var recoveredPerOneMillion;
  var criticalPerOneMillion;
  var flag;
  Tcases({
    this.todayCases, this.cases,this.deaths,this.recovered,this.updated,this.active,this.critical,
    this.todayDeaths,this.todayRecovered,this.flag,this.activePerOneMillion,this.casesPerOneMillion,
    this.criticalPerOneMillion,this.deathsPerOneMillion,this.recoveredPerOneMillion
  });
  factory Tcases.fromJson(final json)
  {
    return Tcases(
      cases: json["cases"],
      deaths : json["deaths"],
      recovered : json["recovered"],
      updated : json["updated"],
      todayCases: json["todayCases"],
      active: json['active'],
      critical: json['critical'],
      todayDeaths: json['todayDeaths'],
      todayRecovered: json['todayRecovered'],
      flag: json['flag'],
      casesPerOneMillion: json['casesPerOneMillion'],
        activePerOneMillion: json['activePerOneMillion'],
        criticalPerOneMillion: json['criticalPerOneMillion'],
        deathsPerOneMillion: json['deathsPerOneMillion'],
        recoveredPerOneMillion: json['recoveredPerOneMillion'],
    );
  }



}