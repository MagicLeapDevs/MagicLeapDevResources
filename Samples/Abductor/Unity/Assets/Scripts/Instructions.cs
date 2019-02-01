using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Instructions : MonoBehaviour {
    private GameObject _camera;
    private GameObject info;
    void Awake()
    {
        _camera = GameObject.Find("/Main Camera");
        info = GameObject.Find("/Info");
        info.transform.position = _camera.transform.position + _camera.transform.forward * 1.0f;
        info.transform.rotation = _camera.transform.rotation;

    }

    void Update () {
        float speed = Time.deltaTime * 5f;

        Vector3 pos = _camera.transform.position + _camera.transform.forward *1.0f;
        info.transform.position = Vector3.SlerpUnclamped(info.transform.position, pos, speed);

        Quaternion rot = Quaternion.LookRotation(info.transform.position - _camera.transform.position);
        info.transform.rotation = Quaternion.Slerp(info.transform.rotation, rot, speed);

    }
}
