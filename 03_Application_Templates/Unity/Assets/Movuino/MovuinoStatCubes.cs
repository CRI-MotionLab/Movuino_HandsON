using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Movuino
{
	public class MovuinoStatCubes : MonoBehaviour
	{
		public GameObject[] statCubes = new GameObject[6];

		void SetCubeScale (int index, float scale)
		{
			var localScale = statCubes [index].transform.localScale;
			statCubes [index].transform.localScale = new Vector3 (localScale.x, scale * 10.0f, localScale.z);
		}

		void Update ()
		{
			var datalist = MovuinoManager.Instance.GetLog<MovuinoSensorData> ();
			foreach (var data in datalist) {
				SetCubeScale (0, data.accelerometer.x);
				SetCubeScale (1, data.accelerometer.y);
				SetCubeScale (2, data.accelerometer.z);
				SetCubeScale (3, data.gyroscope.x);
				SetCubeScale (4, data.gyroscope.y);
				SetCubeScale (5, data.gyroscope.z);
			}
		}
	}
}
