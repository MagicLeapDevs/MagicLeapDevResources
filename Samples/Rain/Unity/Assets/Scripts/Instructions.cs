using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Instructions : MonoBehaviour {

    # region Public Variables
    public GameObject Pages;
    public Camera Camera;
    public GameObject Canvas;
    #endregion

    # region Private Variables
    private GameObject _camera;
    private int _pageIndex = 0;
    public List<GameObject> _pages;
    #endregion

    # region Unity Methods
    void Awake()
    {
        if (Camera == null) {
            Camera = Camera.main;
        }

        gameObject.transform.position = Camera.transform.position + Camera.transform.forward * 1.0f;
        gameObject.transform.rotation = Camera.transform.rotation;

        // Store the pages, child GameObjects of the Pages gameObject
        _pages = new List<GameObject>();
        for (int i=0;i<Pages.transform.childCount;i++) {
            _pages.Add(Pages.transform.GetChild(i).gameObject);
        }
    }

    void Update () {
        float speed = Time.deltaTime * 5f;

        Vector3 pos = Camera.transform.position + Camera.transform.forward *1.0f;
        gameObject.transform.position = Vector3.SlerpUnclamped(gameObject.transform.position, pos, speed);

        Quaternion rot = Quaternion.LookRotation(gameObject.transform.position - Camera.transform.position);
        gameObject.transform.rotation = Quaternion.Slerp(gameObject.transform.rotation, rot, speed);

    }
    #endregion

    # region Public Methods
    public bool NextPage(bool reset = false) {

        // If reset, set pageIndex to 0, else increment pageIndex
        _pageIndex++;
        if (reset) {
             _pageIndex = 0;
        }

        // If last page, hide info screens, return false
        if (_pageIndex >= _pages.Count) {
            SetVisibility(false);
            return false;
        }

        // Set visibility of pageIndex screen
        for (int i=0;i<_pages.Count;i++) {
            _pages[i].SetActive(i == _pageIndex);
        }  

        // Show info screens, return true
        SetVisibility(true); 
        return true; 
    }
    #endregion

    # region Private Methods
    private void SetVisibility(bool state) {
        Canvas.SetActive(state);
    }
    #endregion

}
