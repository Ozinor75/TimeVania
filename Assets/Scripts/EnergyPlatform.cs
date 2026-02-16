using System;
using UnityEngine;

public class EnergyPlatform : MonoBehaviour
{
    public Material platformMaterial;
    public Material energyMaterial;
    private MeshRenderer meshRenderer;
    
    private TimeChanger timeChanger;

    public bool isUsed = false;
    public bool isRespawned = false;
    private Color platformColor;
    void Start()
    {
        timeChanger = GetComponent<TimeChanger>();
        meshRenderer = transform.GetComponent<MeshRenderer>(); 
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
        if (isRespawned)
        {
            meshRenderer.material = energyMaterial;
            isRespawned = false;
        }
    }
}
