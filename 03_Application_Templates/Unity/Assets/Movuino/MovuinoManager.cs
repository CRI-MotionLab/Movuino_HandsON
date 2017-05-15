using UnityEngine;
using System.Collections.Generic;
using System;

namespace Movuino
{
	public class MovuinoManager : MonoBehaviour
	{
		public static MovuinoManager Instance 
		{
			get 
			{
				if (_instance == null) 
				{
					_instance = new GameObject ("OSCHandler").AddComponent<MovuinoManager>();
				}

				return _instance;
			}
		}

		private static MovuinoManager _instance = null;
		/// <summary>
		/// The client data.
		/// </summary>
		[Tooltip("The client data.")]
		public ClientData clientData = new ClientData ("OSCClient", "127.0.0.1", 3011);
		/// <summary>
		/// The server data.
		/// </summary>
		[Tooltip("The server data.")]
		public ServerData serverData = new ServerData ("OSCServer", 7400);

		void Start()
		{
			if (_instance != null && _instance != this)
				Destroy (this.gameObject);
			else {
				_instance = this;
			}
			OSCHandler.Instance.Init (serverData, clientData);
		}

		public Stack<T> GetLog<T>() where T : MovuinoData, new()
		{
			var address = MovuinoData.CreateMovuinoData<T> ().movuinoAddress;
			return GetLog<T> (address);
		}

		/// <summary>
		/// Gets the log.
		/// </summary>
		/// <returns>The log.</returns>
		/// <param name="serverLogAddresses">Server log addresses.</param>
		/// <typeparam name="T">A Movuino Data type.</typeparam>
		public Stack<T> GetLog<T>(string logAddress) where T : MovuinoData, new()
		{
			return GetLog<T> (new List<string> (new string[] { logAddress }));
		}

		/// <summary>
		/// Gets the log.
		/// </summary>
		/// <returns>The log.</returns>
		/// <param name="serverLogAddresses">Server log addresses.</param>
		/// <typeparam name="T">A Movuino Data type.</typeparam>
		public Stack<T> GetLog<T>(List<string> serverLogAddresses) where T : MovuinoData, new()
		{
			var res = new Stack<T> ();
			foreach (KeyValuePair<string, ServerLog> item in OSCHandler.Instance.Servers) {
				var serverName = item.Key;
				var serverLog = item.Value;
				foreach (var packet in serverLog.packets) {
					foreach (var logAddress in serverLogAddresses) {
						if (packet.Address == "/" + logAddress || packet.Address == logAddress) {
							res.Push (MovuinoData.CreateMovuinoData<T>(packet.Data));
						}
					}
				}
			}
			return res;
		}

		void Update()
		{
			OSCHandler.Instance.UpdateLogs ();
		}
	}
}

