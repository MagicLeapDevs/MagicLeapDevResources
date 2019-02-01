using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Panel : MonoBehaviour {
    private GameObject _camera;
    private GameObject panel;
    void Awake()
    {
        _camera = GameObject.Find("/Main Camera");
        panel = GameObject.Find("/Info/Canvas/Panel");
		panel.SetActive(true); 

        panel.transform.position = _camera.transform.position;
        panel.transform.rotation = _camera.transform.rotation;

    }

    void Update () {
		panel.transform.position = _camera.transform.position;
        panel.transform.rotation = _camera.transform.rotation;
    }
}
