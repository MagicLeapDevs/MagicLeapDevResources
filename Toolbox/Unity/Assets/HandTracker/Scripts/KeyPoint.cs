using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KeyPoint : MonoBehaviour {
	
	public GameObject _MainCam;
	
	public GameObject _sphere;
	
	public GameObject _label;
	public GameObject _sphereScale;
	
	void Update () {
        	Vector3 relativePos = _MainCam.transform.position - transform.position;
        	transform.rotation = Quaternion.LookRotation (relativePos);		
	}
}
