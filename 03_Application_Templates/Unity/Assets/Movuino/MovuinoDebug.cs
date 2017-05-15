using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Movuino
{
	public class MovuinoDebug : MonoBehaviour
	{
		// Update is called once per frame
		void Update ()
		{
			var sensorDataList = MovuinoManager.Instance.GetLog<MovuinoSensorData> ();
			var sensorRepList = MovuinoManager.Instance.GetLog<MovuinoSensorRep> ();
			var xmmList = MovuinoManager.Instance.GetLog<MovuinoXMM> ();

			foreach (var sensorData in sensorDataList) {
				Debug.Log ("Movuino accelerometer data = " + sensorData.accelerometer);
				Debug.Log ("Movuino gyroscope data = " + sensorData.gyroscope);
				Debug.Log ("Movuino magnetometer data = " + sensorData.magnetometer);
			}
			foreach (var sensorRep in sensorRepList) {
				Debug.Log ("Movuino repetitions = " + sensorRep.repAcc + ", " + sensorRep.repGyr + ", "  + sensorRep.repMag);
			}
			foreach (var xmm in xmmList) {
				Debug.Log ("Movuino recognition = " + xmm.gestId + ", " + xmm.gestProg);
			}
		}
	}
}