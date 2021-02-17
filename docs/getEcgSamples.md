Query to get all Electrocardiograms.  

```javascript 1.7
let options = {
  unit: 'bpm', // optional; default 'bpm'
  startDate: (new Date(2016,4,27)).toISOString(), // required
  endDate: (new Date()).toISOString(), // optional; default now
  ascending: false, // optional; default false
  limit:10, // optional; default no limit
};
```

The callback function will be called with a `samples` array containing objects with *uuid*, *startDate*, *averageHr*, *classification*, *voltage* and *frequency* fields

```javascript 1.7
AppleHealthKit.getSamples(options, (err: Object, results: Array<EcgValue>) => {
  if (err) {
    return;
  }
  console.log(results)
});
```

Example:
```
{
  uuid: string, // [[HKElectrocardiogram UUID] UUIDString]
  startDate: string // [RCTAppleHealthKit buildISO8601StringFromDate:HKElectrocardiogram.startDate]
  averageHr: number // [[HKElectrocardiogram averageHeartRate] doubleValueForUnit:unit]
  classification: String // [RCTAppleHealthKit ecgClassificationToString:HKElectrocardiogram.classification]
  voltage: string[] // [NSMutableArray]
  frequency: number // [[HKElectrocardiogram frequency] doubleValueForUnit:[HKUnit hertzUnit]]
}
```

Possible values for classification:
- "SinusRhythm" - `[HKElectrocardiogramClassificationSinusRhythm]`
- "AtrialFibrillation" - `[HKElectrocardiogramClassificationAtrialFibrillation]`
- "InconclusiveLowHeartRate" - `[HKElectrocardiogramClassificationInconclusiveLowHeartRate]`
- "InconclusiveHighHeartRate" - `[HKElectrocardiogramClassificationInconclusiveHighHeartRate]`
- "InconclusiveOther" - `[HKElectrocardiogramClassificationInconclusiveOther]`
- "Unrecognized" - `[HKElectrocardiogramClassificationUnrecognized]` (used as a default value)
