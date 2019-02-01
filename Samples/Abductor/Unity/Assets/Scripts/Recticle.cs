using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Recticle : MonoBehaviour {
	public float rotateSpeed = 30f;
	
	void Update () {
		transform.Rotate(Vector3.up * Time.deltaTime * rotateSpeed, Space.World);
	}
}
