using System.Collections.Generic;
using UnityEngine;

namespace Movuino
{
	/// <summary>
	/// Inherit this if you want to represent a Movuino Data Type
	/// </summary>
	public abstract class MovuinoData
	{
		public string movuinoAddress { get { return GetAddress (); } }
		public class WrongMovuinoDataFormatException : UnityException
		{

		};

		public static T CreateMovuinoData<T> () where T : MovuinoData, new()
		{
			T newMovuinoData = new T ();
			return newMovuinoData;
		}

		public static T CreateMovuinoData<T> (List<object> list) where T : MovuinoData, new()
		{
			T newMovuinoData = new T ();
			newMovuinoData.ToMovuinoData (list);
			return newMovuinoData;
		}

		protected abstract void ToMovuinoData (List<object> list);
		protected abstract string GetAddress();
	}

	/// <summary>
	/// Data for the accelerometer and the gyroscope of Movuino
	/// </summary>
	public class MovuinoSensorData : MovuinoData
	{
		/// <summary>
		/// Accelerometer data.
		/// </summary>
		public Vector3 accelerometer;
		/// <summary>
		/// Gysocope data.
		/// </summary>
		public Vector3 gyroscope;
		/// <summary>
		/// Magnetometer data.
		/// </summary>
		public Vector3 magnetometer;

		public static string address = "/sensorData";



		protected override void ToMovuinoData (List<object> list)
		{
			try {
				if (list.Count >= 9) {
					float ax = (float)list [0];
					float ay = (float)list [1];
					float az = (float)list [2];
					float gx = (float)list [3];
					float gy = (float)list [4];
					float gz = (float)list [5];
					float mx = (float)list [6];
					float my = (float)list [7];
					float mz = (float)list [8];
					this.accelerometer = new Vector3 (ax, ay, az);
					this.gyroscope = new Vector3 (gx, gy, gz);
					this.magnetometer = new Vector3 (mx, my, mz);
				} else {
					throw new WrongMovuinoDataFormatException ();
				}
			} catch (UnityException) {
				throw new WrongMovuinoDataFormatException ();
			}
		}

		protected override string GetAddress ()
		{
			return address;
		}

		public override string ToString ()
		{
			return string.Format ("[MovuinoSensorData] = "
			+ "Accelerometer = "
			+ accelerometer.ToString ()
			+ " Gyroscope = "
			+ gyroscope.ToString ()
			+ " Magnetometer = "
			+ magnetometer.ToString ());
		}
	}

	public class MovuinoXMM : MovuinoData
	{

		public int gestId;
		public float gestProg;

		public static string address = "/xmm";

		protected override void ToMovuinoData (List<object> list)
		{
			try {
				if (list.Count >= 2) {
					this.gestId = (int)list [0];
					this.gestProg = Mathf.Clamp ((float)list [1], 0.0f, 1.0f);
				} else {
					throw new WrongMovuinoDataFormatException ();
				}
			} catch (UnityException) {
				throw new WrongMovuinoDataFormatException ();
			}
		}
			
		protected override string GetAddress ()
		{
			return address;
		}

		public override string ToString ()
		{
			return string.Format ("[MovuinoXMM] = "
			+ "xmmGestId = "
			+ gestId.ToString ()
			+ "xmmGestProg = "
			+ gestProg.ToString ());
		}
	}

	public class MovuinoSensorRep : MovuinoData
	{
		public bool repAcc = false;
		public bool repGyr = false;
		public bool repMag = false;
		public static string address = "/sensorRep";

		protected override void ToMovuinoData (List<object> list)
		{
			try {
				if (list.Count >= 3) {
					this.repAcc = (int)list [0] != 0; // conversion to bool
					this.repGyr = (int)list [1] != 0;
					this.repMag = (int)list [2] != 0;
				} else {
					throw new WrongMovuinoDataFormatException ();
				}
			} catch (UnityException) {
				throw new WrongMovuinoDataFormatException ();
			}
		}

		protected override string GetAddress ()
		{
			return address;
		}

		public override string ToString ()
		{
			return string.Format ("[MovuinoSensorRep] = "
				+ "repAcc = "
				+ repAcc.ToString ()
				+ "repGyr = "
				+ repGyr.ToString ()
				+ "repMag = "
				+ repMag.ToString ());
		}
	}

}

