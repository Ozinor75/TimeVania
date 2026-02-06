using System;
using UnityEngine;

public class EnergyPlatform : MonoBehaviour
{
    public Material platformMaterial;
    private MeshRenderer meshRenderer;
    
    private TimeChanger timeChanger;

    private bool isUsed = false;
    private Color platformColor;
    void Start()
    {
        timeChanger = GetComponent<TimeChanger>();
        meshRenderer = transform.GetChild(0).GetComponent<MeshRenderer>();
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player") && !isUsed)
        {
            timeChanger.ChangeTime();
            meshRenderer.material = platformMaterial;
            isUsed = true;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
