using UnityEngine;

public class MareeScale : MonoBehaviour
{
    [Header("Paramètres de la marée")]
    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;    
    
    [Header("Objet Flottant (Le Holder)")]
    public Transform holder;
    public float scaleMinimumY = 1f;
    public float scaleMaximumY = 5f;

    private Vector3 positionInitiale;
    private Vector3 scaleInitial;
    private float offsetHolderY;
    
    public GlobalTime globalTime;
    public float timeScale;
    private float tempsAccumule = 0f;
    
    void Start()
    {
        positionInitiale = transform.localPosition;
        scaleInitial = transform.localScale;
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
        
        if (holder != null)
        {
            float sommetInitialY = transform.position.y + (transform.lossyScale.y / 2f);
            offsetHolderY = holder.position.y - sommetInitialY;
        }
    }

    void Update()
    {
        switch (globalTime.worldTime)
        {
            case WorldTime.ONE:
                timeScale = acceleratedTime;
                break;
            case WorldTime.TWO:
                timeScale = normalTime;
                break;
            case WorldTime.THREE:
                timeScale = slowedTime;
                break;
        }
        tempsAccumule += Time.deltaTime * timeScale;
        float vague = (Mathf.Sin(tempsAccumule) + 1f) / 2f;
        float nouveauScaleY = Mathf.Lerp(scaleMinimumY, scaleMaximumY, vague);
        
        Vector3 nouveauScale = scaleInitial;
        nouveauScale.y = nouveauScaleY;
        transform.localScale = nouveauScale;
        
        Vector3 nouvellePosition = positionInitiale;
        float differenceDeTaille = nouveauScaleY - scaleInitial.y;
        nouvellePosition.y = positionInitiale.y + (differenceDeTaille / 2f);
        
        transform.localPosition = nouvellePosition;
        
        if (holder != null)
        {
            float sommetActuelY = transform.position.y + (transform.lossyScale.y / 2f);
            Vector3 positionHolder = holder.position;
            positionHolder.y = sommetActuelY + offsetHolderY;
            holder.position = positionHolder;
        }
    }
}