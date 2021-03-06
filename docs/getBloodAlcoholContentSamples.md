# getBloodAlcoholContentSamples

Query for blood alcohol content samples. The options object is used to setup a query to retrieve relevant samples.

Example input options:

```javascript
let options = {
  startDate: new Date(2021, 0, 0).toISOString(), // required
  endDate: new Date().toISOString(), // optional; default now
  ascending: false, // optional; default false
  limit: 10, // optional; default no limit
}
```

Call the method:

```javascript
AppleHealthKit.getBloodAlcoholContentSamples(
  options,
  (err: Object, results: Array<HealthValue>) => {
    if (err) {
      return
    }
    console.log(results)
  },
)
```

Example output:

```json
[
  {
    "endDate": "2020-09-29T22:09:35.527+0200",
    "sourceId": "com.example.app",
    "sourceName": "app",
    "startDate": "2020-09-29T22:09:35.527+0200",
    "value": 0.003
  },
  {
    "endDate": "2020-09-29T21:52:00.000+0200",
    "sourceId": "com.apple.Health",
    "sourceName": "Helse",
    "startDate": "2020-09-29T21:52:00.000+0200",
    "value": 0.001
  },
  {
    "endDate": "2020-09-28T22:46:00.000+0200",
    "sourceId": "com.apple.Health",
    "sourceName": "Helse",
    "startDate": "2020-09-28T22:46:00.000+0200",
    "value": 0.00015
  }
]
```
